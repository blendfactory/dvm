import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/app/servicies/abi_service.dart';
import 'package:dvm/src/app/servicies/console_service.dart';
import 'package:dvm/src/features/project_config/services/project_config_service.dart';
import 'package:dvm/src/features/sdk/models/sdk_version.dart';
import 'package:dvm/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
    projectConfigService,
    abiService,
  ],
)
UseCommandService useCommandService(
  UseCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final abiService = ref.watch(abiServiceProvider);
  return UseCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
    projectConfigService: projectConfigService,
    abiService: abiService,
  );
}

final class UseCommandService {
  const UseCommandService({
    required ConsoleService consoleService,
    required SdkService sdkService,
    required ProjectConfigService projectConfigService,
    required AbiService abiService,
  })  : _consoleService = consoleService,
        _sdkService = sdkService,
        _projectConfigService = projectConfigService,
        _abiService = abiService;

  final ConsoleService _consoleService;
  final SdkService _sdkService;
  final ProjectConfigService _projectConfigService;
  final AbiService _abiService;

  Future<ExitStatus> call({
    required SdkVersion? version,
    required ThrowUsageException throwUsageException,
  }) async {
    final SdkVersion sdkVersion;
    if (version == null) {
      final projectSdkVersion = _projectConfigService.findProjectSdkVersion();
      if (projectSdkVersion == null) {
        throwUsageException(
          'Please specify a version or set a version in project config.',
        );
      }
      sdkVersion = projectSdkVersion;
    } else {
      sdkVersion = version;
    }

    final existsSdk = _sdkService.exitsSdk(version: sdkVersion);
    if (!existsSdk) {
      _consoleService.info('$sdkVersion is not installed.');

      final shouldInstall = _consoleService.confirm(
        'Would you like to install $sdkVersion?',
      );
      if (!shouldInstall) {
        return ExitStatus.success;
      }

      final (os: os, arch: arch) = _abiService.getOsAndArch();

      final installProgress =
          _consoleService.progress('Installing $sdkVersion');
      try {
        await _sdkService.installSdk(
          os: os,
          arch: arch,
          version: sdkVersion,
        );
        installProgress.complete('Installed $sdkVersion.');
      } on Exception catch (e) {
        installProgress.fail(
          'Failed to install $sdkVersion. error: $e',
        );
        return ExitStatus.error;
      }
    }

    final updateSettingsProgress = _consoleService.progress(
      'Updating settings with Dart SDK version $sdkVersion',
    );
    try {
      _projectConfigService.updateSettings(sdkVersion);
      updateSettingsProgress.complete(
        'Updated settings with Dart SDK version $sdkVersion',
      );
    } on Exception catch (e) {
      updateSettingsProgress.fail(
        'Failed to update settings with Dart SDK version $sdkVersion.\n$e',
      );
      return ExitStatus.error;
    }
    return ExitStatus.success;
  }
}

typedef ThrowUsageException = Never Function(String message);
