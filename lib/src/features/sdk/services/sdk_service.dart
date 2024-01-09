import 'dart:convert';
import 'dart:io';

import 'package:dvm/src/cores/local/file_system.dart';
import 'package:dvm/src/cores/network/dvm_client.dart';
import 'package:dvm/src/features/sdk/models/sdk_channel.dart';
import 'package:dvm/src/features/sdk/models/sdk_version.dart';
import 'package:file/file.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sdk_service.g.dart';

@Riverpod(
  dependencies: [
    fileSystem,
  ],
)
Directory sdkCacheDir(SdkCacheDirRef ref) {
  final fileSystem = ref.watch(fileSystemProvider);
  final userHome = Platform.isWindows
      ? Platform.environment['USERPROFILE']!
      : Platform.environment['HOME']!;
  return fileSystem.directory('$userHome/.dvm/cache/versions');
}

@Riverpod(
  dependencies: [
    dvmClient,
    sdkCacheDir,
  ],
)
SdkService sdkService(SdkServiceRef ref) {
  final dvmClient = ref.watch(dvmClientProvider);
  final sdkCacheDir = ref.watch(sdkCacheDirProvider);
  return SdkService(
    dvmClient: dvmClient,
    sdkCacheDir: sdkCacheDir,
  );
}

final class SdkService {
  SdkService({
    required DvmClient dvmClient,
    required Directory sdkCacheDir,
  })  : _dvmClient = dvmClient,
        _sdkCacheDir = sdkCacheDir;

  final DvmClient _dvmClient;
  final Directory _sdkCacheDir;

  Future<List<SdkVersion>> getSdkVersions({
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

  bool exitsSdk({
    required SdkVersion version,
  }) {
    final versionCacheDir = _sdkCacheDir.childDirectory(version.toString());
    return versionCacheDir.existsSync();
  }

  Future<void> installSdk({
    required SdkVersion version,
  }) async {}

  Future<void> activateSdk({
    required SdkVersion version,
  }) async {}
}
