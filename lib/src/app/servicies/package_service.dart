import 'dart:convert';

import 'package:cli_info/cli_info.dart';
import 'package:dvmx/src/app/gen/cli_info.dart';
import 'package:dvmx/src/cores/network/dvm_client.dart';
import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_service.g.dart';

@Riverpod(
  dependencies: [
    dvmClient,
  ],
)
PackageService packageService(PackageServiceRef ref) {
  final dvmClient = ref.watch(dvmClientProvider);
  return PackageService(
    cliInfo: cliInfo,
    dvmClient: dvmClient,
  );
}

final class PackageService {
  PackageService({
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

  Future<VersionStatus> checkVersion() async {
    final Version current;
    final Version latest;
    try {
      current = getCurrentVersion();
      latest = await getLatestVersion();
    } on FormatException catch (e) {
      return VersionStatus.formatError(e);
    } on ClientException catch (e) {
      return VersionStatus.networkError(e);
    } on Exception catch (e) {
      return VersionStatus.unknownError(e);
    }

    if (current > latest) {
      return const VersionStatus.aheadOfLatestError();
    }

    if (current == latest) {
      return const VersionStatus.upToDate();
    }

    return VersionStatus.outdated(
      current: current,
      latest: latest,
    );
  }
}

sealed class VersionStatus {
  const VersionStatus();
  const factory VersionStatus.upToDate() = UpToDate;
  const factory VersionStatus.outdated({
    required Version current,
    required Version latest,
  }) = Outdated;

  const factory VersionStatus.aheadOfLatestError() = AheadOfLatestError;
  const factory VersionStatus.formatError(FormatException e) = FormatError;
  const factory VersionStatus.networkError(ClientException e) = NetworkError;
  const factory VersionStatus.unknownError(Exception e) = UnknownError;
}

final class UpToDate extends VersionStatus {
  const UpToDate();
}

final class Outdated extends VersionStatus {
  const Outdated({
    required this.current,
    required this.latest,
  });
  final Version current;
  final Version latest;
}

sealed class PackageVersionStatusError extends VersionStatus {
  const PackageVersionStatusError(this.e);
  final Exception? e;
}

final class AheadOfLatestError extends PackageVersionStatusError {
  const AheadOfLatestError() : super(null);
}

final class FormatError extends PackageVersionStatusError {
  const FormatError(FormatException super.e);
}

final class NetworkError extends PackageVersionStatusError {
  const NetworkError(ClientException super.e);
}

final class UnknownError extends PackageVersionStatusError {
  const UnknownError(Exception super.e);
}
