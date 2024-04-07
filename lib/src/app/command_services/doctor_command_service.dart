import 'package:dvmx/src/app/models/check_status.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/features/global_config/models/global_config_status.dart';
import 'package:dvmx/src/features/global_config/services/global_config_service.dart';
import 'package:dvmx/src/features/package_version/models/package_version_status.dart';
import 'package:dvmx/src/features/package_version/services/package_version_service.dart';
import 'package:dvmx/src/features/project_config/models/project_config_status.dart';
import 'package:dvmx/src/features/project_config/services/project_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'doctor_command_service.g.dart';

@Riverpod(
  dependencies: [
    consoleService,
    packageVersionService,
    globalConfigService,
    projectConfigService,
  ],
)
DoctorCommandService doctorCommandService(
  DoctorCommandServiceRef ref,
) {
  final consoleService = ref.watch(consoleServiceProvider);
  final packageVersionService = ref.watch(packageVersionServiceProvider);
  final globalConfigService = ref.watch(globalConfigServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  return DoctorCommandService(
    consoleService: consoleService,
    packageVersionService: packageVersionService,
    globalConfigService: globalConfigService,
    projectConfigService: projectConfigService,
  );
}

final class DoctorCommandService {
  const DoctorCommandService({
    required ConsoleService consoleService,
    required PackageVersionService packageVersionService,
    required GlobalConfigService globalConfigService,
    required ProjectConfigService projectConfigService,
  })  : _consoleService = consoleService,
        _packageVersionService = packageVersionService,
        _globalConfigService = globalConfigService,
        _projectConfigService = projectConfigService;

  final ConsoleService _consoleService;
  final PackageVersionService _packageVersionService;
  final GlobalConfigService _globalConfigService;
  final ProjectConfigService _projectConfigService;

  Future<ExitStatus> call() async {
    final progress = _consoleService.progress('Checking...');
    final packageVersionStatus =
        await _packageVersionService.checkPackageVersion();
    final globalConfigStatus = _globalConfigService.checkGlobalConfig();
    final projectConfigStatus = _projectConfigService.checkProjectConfig();
    progress.complete('Check completed.');

    _consoleService.spacer();
    _consoleService.info('Doctor summary:');
    final checkResults = [
      packageVersionStatus.toCheckResult(),
      globalConfigStatus.toCheckResult(),
      projectConfigStatus.toCheckResult(),
    ];
    checkResults.forEach(_consoleService.checkResult);

    return ExitStatus.success;
  }
}

extension on PackageVersionStatus {
  CheckResult toCheckResult() {
    return switch (this) {
      PackageVersionStatusUpToDate() => (
          status: CheckStatus.success,
          summary: 'Your CLI is up to date. No update is required.',
          detail: null,
        ),
      PackageVersionStatusOutdated(current: final c, latest: final l) => (
          status: CheckStatus.warning,
          summary: 'Your CLI is outdated. Current: $c, Latest: $l.',
          detail: null,
        ),
      final PackageVersionStatusError error => () {
          final summary = switch (error) {
            PackageVersionStatusAheadOfLatestError() =>
              'Your CLI is ahead of the latest package version.',
            PackageVersionStatusNetworkError() =>
              'Failed to fetch the latest package version.',
            PackageVersionStatusFormatError() =>
              'Failed to format the data for the latest package version.',
            PackageVersionStatusUnknownError() =>
              '''An unexpected error occurred while fetching the latest package version.''',
          };
          return (
            status: CheckStatus.error,
            summary: summary,
            detail: error.e?.toString(),
          );
        }(),
    };
  }
}

extension on GlobalConfigStatus {
  CheckResult toCheckResult() {
    return switch (this) {
      GlobalConfigStatusFound(globalConfig: final config) => (
          status: CheckStatus.success,
          summary: 'Global config found.',
          detail: config.toString(),
        ),
      GlobalConfigStatusNotFound() => (
          status: CheckStatus.success,
          summary: 'Global config not found.',
          detail: null,
        ),
      final GlobalConfigStatusError error => () {
          final summary = switch (error) {
            GlobalConfigStatusJsonFormatError() =>
              'Invalid JSON format in the global config file.',
            GlobalConfigStatusParamFormatError() =>
              'Invalid parameter format in the global config file.',
            GlobalConfigStatusUnknownError() =>
              '''An unexpected error occurred while reading the global config file.''',
          };
          return (
            status: CheckStatus.error,
            summary: summary,
            detail: error.e?.toString(),
          );
        }(),
    };
  }
}

extension on ProjectConfigStatus {
  CheckResult toCheckResult() {
    return switch (this) {
      ProjectConfigStatusFound(projectConfig: final config) => (
          status: CheckStatus.success,
          summary: 'Project config found.',
          detail: config.toString(),
        ),
      ProjectConfigStatusNotFound() => (
          status: CheckStatus.success,
          summary: 'Project config not found.',
          detail: null,
        ),
      final ProjectConfigStatusError error => () {
          final summary = switch (error) {
            ProjectConfigStatusJsonFormatError() =>
              'Invalid JSON format in the project config file.',
            ProjectConfigStatusParamFormatError() =>
              'Invalid parameter format in the project config file.',
            ProjectConfigStatusUnknownError() =>
              '''An unexpected error occurred while reading the project config file.''',
          };
          return (
            status: CheckStatus.error,
            summary: summary,
            detail: error.e?.toString(),
          );
        }(),
    };
  }
}
