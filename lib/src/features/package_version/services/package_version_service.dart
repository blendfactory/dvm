import 'dart:convert';

import 'package:cli_info/cli_info.dart';
import 'package:dvmx/src/cores/local/cli_info.dart';
import 'package:dvmx/src/cores/network/dvm_client.dart';
import 'package:dvmx/src/features/package_version/models/package_version_status.dart';
import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_version_service.g.dart';

@Riverpod(
  dependencies: [
    cliInfo,
    dvmClient,
  ],
)
PackageVersionService packageVersionService(PackageVersionServiceRef ref) {
  final cliInfo = ref.watch(cliInfoProvider);
  final dvmClient = ref.watch(dvmClientProvider);
  return PackageVersionService(
    cliInfo: cliInfo,
    dvmClient: dvmClient,
  );
}

final class PackageVersionService {
  PackageVersionService({
    required CliInfo cliInfo,
    required DvmClient dvmClient,
  })  : _cliInfo = cliInfo,
        _dvmClient = dvmClient;

  final CliInfo _cliInfo;
  final DvmClient _dvmClient;

  Version getCurrentVersion() {
    return Version.parse(_cliInfo.version);
  }

  Future<Version> getLatestVersion() async {
    final url = Uri.https('pub.dev', 'api/packages/dvmx');
    final responseBody = await _dvmClient.read(url);
    final jsonObject = jsonDecode(responseBody) as Map<String, dynamic>?;
    if (jsonObject == null) {
      throw ClientException('Failed to convert response body to json object.');
    }
    final latestObject = jsonObject['latest'] as Map<String, dynamic>?;
    if (latestObject == null) {
      throw ClientException('Failed to convert json object to latest object.');
    }
    final version = latestObject['version'] as String?;
    if (version == null) {
      throw ClientException('Failed to convert latest object to version.');
    }
    return Version.parse(version);
  }

  Future<PackageVersionStatus> checkPackageVersion() async {
    final Version current;
    final Version latest;
    try {
      current = getCurrentVersion();
      latest = await getLatestVersion();
    } on FormatException catch (e) {
      return PackageVersionStatus.formatError(e);
    } on ClientException catch (e) {
      return PackageVersionStatus.networkError(e);
    } on Exception catch (e) {
      return PackageVersionStatus.unknownError(e);
    }

    if (current > latest) {
      return PackageVersionStatus.aheadOfLatestError(
        current: current,
        latest: latest,
      );
    }

    if (current == latest) {
      return const PackageVersionStatus.upToDate();
    }

    return PackageVersionStatus.outdated(
      current: current,
      latest: latest,
    );
  }
}
