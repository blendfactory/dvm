import 'dart:convert';

import 'package:dvm/src/cores/network/dvm_client.dart';
import 'package:dvm/src/features/sdk/models/sdk_channel.dart';
import 'package:dvm/src/features/sdk/models/sdk_version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sdk_service.g.dart';

@Riverpod(dependencies: [dvmClient])
SdkService sdkService(SdkServiceRef ref) {
  final dvmClient = ref.watch(dvmClientProvider);
  return SdkService(dvmClient: dvmClient);
}

final class SdkService {
  SdkService({
    required DvmClient dvmClient,
  }) : _dvmClient = dvmClient;

  final DvmClient _dvmClient;

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
      throw FormatException(
        'The type of `json` should be `Map<String, dynamic>`.',
      );
    }
    final prefixes = json['prefixes'];
    if (prefixes is! List<dynamic>) {
      throw FormatException(
        'The type of `prefixes` should be `List<dynamic>`.',
      );
    }

    final versions = prefixes
        .map((prefix) {
          if (prefix is! String) {
            throw FormatException(
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
}
