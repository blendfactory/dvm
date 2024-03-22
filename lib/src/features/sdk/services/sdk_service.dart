import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dvmx/src/cores/local/permission_client.dart';
import 'package:dvmx/src/cores/local/sdk_cache_dir.dart';
import 'package:dvmx/src/cores/local/system_temp_dir.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/cores/network/dvm_client.dart';
import 'package:dvmx/src/features/sdk/models/architecture.dart';
import 'package:dvmx/src/features/sdk/models/operating_system.dart';
import 'package:file/file.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sdk_service.g.dart';

@Riverpod(
  dependencies: [
    dvmClient,
    sdkCacheDir,
    systemTempDir,
    permissionClient,
  ],
)
SdkService sdkService(SdkServiceRef ref) {
  final dvmClient = ref.watch(dvmClientProvider);
  final sdkCacheDir = ref.watch(sdkCacheDirProvider);
  final systemTempDir = ref.watch(systemTempDirProvider);
  final permissionClient = ref.watch(permissionClientProvider);
  return SdkService(
    dvmClient: dvmClient,
    sdkCacheDir: sdkCacheDir,
    systemTempDir: systemTempDir,
    zipDecoder: ZipDecoder(),
    permissionClient: permissionClient,
  );
}

final class SdkService {
  SdkService({
    required DvmClient dvmClient,
    required Directory sdkCacheDir,
    required Directory systemTempDir,
    required ZipDecoder zipDecoder,
    required PermissionClient permissionClient,
  })  : _dvmClient = dvmClient,
        _sdkCacheDir = sdkCacheDir,
        _systemTempDir = systemTempDir,
        _zipDecoder = zipDecoder,
        _permissionClient = permissionClient;

  final DvmClient _dvmClient;
  final Directory _sdkCacheDir;
  final Directory _systemTempDir;
  final ZipDecoder _zipDecoder;
  final PermissionClient _permissionClient;

  Future<List<SdkVersion>> getSdks({
    required SdkChannel? channel,
  }) async {
    final channels = channel == null ? SdkChannel.values : [channel];
    final versions = await Future.wait(
      channels.map((channel) => _getSdks(channel: channel)),
    );
    return versions.expand((version) => version).sorted();
  }

  Future<List<SdkVersion>> _getSdks({
    required SdkChannel channel,
  }) async {
    final url = Uri.https(
      'storage.googleapis.com',
      '/storage/v1/b/dart-archive/o',
      {
        'delimiter': '/',
        'prefix': 'channels/${channel.name}/release/',
      },
    );

    final responseBody = await _dvmClient.read(url);
    final json = jsonDecode(responseBody);
    if (json is! Map<String, dynamic>) {
      throw ClientException(
        'The type of `json` should be `Map<String, dynamic>`.',
      );
    }
    final prefixes = json['prefixes'];
    if (prefixes is! List<dynamic>) {
      throw ClientException(
        'The type of `prefixes` should be `List<dynamic>`.',
      );
    }

    final versions = prefixes
        .map((prefix) {
          if (prefix is! String) {
            throw ClientException(
              'The type of `prefix` should be `String`.',
            );
          }

          const nameVersion = 'version';
          final regex = RegExp(
            '''^channels/${channel.name}/release/(?<$nameVersion>.*)/\$''',
          );
          final match = regex.firstMatch(prefix);
          if (match == null) {
            return null;
          }
          final versionText = match.namedGroup(nameVersion)!;

          try {
            return SdkVersion.fromString(versionText);
          } on FormatException catch (_) {
            return null;
          }
        })
        .nonNulls
        .where((version) => channel == version.channel)
        .toList();
    return versions;
  }

  Future<SdkVersion> getLatestSdk({
    required SdkChannel channel,
  }) async {
    final versions = await getSdks(channel: channel);
    if (versions.isEmpty) {
      throw Exception('Could not find Dart SDK');
    }
    return versions.last;
  }

  Future<List<SdkVersion>> getInstalledSdks({
    required SdkChannel? channel,
  }) async {
    if (!_sdkCacheDir.existsSync()) {
      return [];
    }

    final versions = _sdkCacheDir
        .listSync()
        .whereType<Directory>()
        .map((dir) {
          try {
            return SdkVersion.fromString(dir.basename);
          } on FormatException catch (_) {
            return null;
          }
        })
        .nonNulls
        .where((version) => channel == null || version.channel == channel)
        .sorted()
        .toList();
    return versions;
  }

  bool exitsSdk({
    required SdkVersion version,
  }) {
    final versionCacheDir = _sdkCacheDir.childDirectory(version.toString());
    return versionCacheDir.existsSync();
  }

  Future<void> installSdk({
    required OperatingSystem os,
    required Architecture arch,
    required SdkVersion version,
  }) async {
    if (!_sdkCacheDir.existsSync()) {
      _sdkCacheDir.createSync(recursive: true);
    }

    final url = Uri(
      scheme: 'https',
      host: 'storage.googleapis.com',
      pathSegments: [
        'dart-archive',
        'channels',
        version.channel.name,
        'release',
        version.toString(),
        'sdk',
        'dartsdk-$os-$arch-release.zip',
      ],
    );
    final responseBodyBytes = await _dvmClient.readBytes(url);

    final archive = _zipDecoder.decodeBytes(responseBodyBytes);
    extractArchiveToDisk(archive, _systemTempDir.path);

    final sdkDir = _systemTempDir.childDirectory('dart-sdk');
    if (!sdkDir.existsSync()) {
      throw Exception('Could not find Dart SDK');
    }

    final versionCacheDir = _sdkCacheDir.childDirectory(version.toString());
    sdkDir.renameSync(versionCacheDir.path);

    if (os case OperatingSystem.macos || OperatingSystem.linux) {
      final dartBin = versionCacheDir.childFile('bin/dart');
      if (!dartBin.existsSync()) {
        throw Exception('Could not find Dart SDK');
      }
      await _permissionClient.grantExecPermission(dartBin);

      final dartAotRuntimeBin = versionCacheDir.childFile('bin/dartaotruntime');
      if (!dartAotRuntimeBin.existsSync()) {
        throw Exception('Could not find Dart AOT Runtime');
      }
      await _permissionClient.grantExecPermission(dartAotRuntimeBin);
    }
  }

  Future<void> uninstallSdk({
    required SdkVersion version,
  }) async {
    final versionCacheDir = _sdkCacheDir.childDirectory(version.toString());
    if (versionCacheDir.existsSync()) {
      versionCacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> uninstallAllSdks() async {
    if (_sdkCacheDir.existsSync()) {
      _sdkCacheDir.deleteSync(recursive: true);
    }
  }
}
