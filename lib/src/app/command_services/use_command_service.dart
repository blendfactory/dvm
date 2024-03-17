import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/abi_service.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/features/global_config/services/global_config_service.dart';
import 'package:dvmx/src/features/project_config/services/project_config_service.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
    projectConfigService,
    globalConfigService,
    abiService,
  ],
)
UseCommandService useCommandService(
  UseCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final globalConfigService = ref.watch(globalConfigServiceProvider);
  final abiService = ref.watch(abiServiceProvider);
  return UseCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
    projectConfigService: projectConfigService,
    globalConfigService: globalConfigService,
    abiService: abiService,
  );
}

final class UseCommandService {
  const UseCommandService({
    required ConsoleService consoleService,
    required SdkService sdkService,
    required ProjectConfigService projectConfigService,
    required GlobalConfigService globalConfigService,
    required AbiService abiService,
  })  : _consoleService = consoleService,
        _sdkService = sdkService,
        _projectConfigService = projectConfigService,
        _globalConfigService = globalConfigService,
        _abiService = abiService;

  final ConsoleService _consoleService;
  final SdkService _sdkService;
  final ProjectConfigService _projectConfigService;
  final GlobalConfigService _globalConfigService;
  final AbiService _abiService;

  Future<ExitStatus> call({
    required SdkVersion? version,
    required LatestOptions latestOptions,
    required bool isGlobal,
    required ThrowUsageException throwUsageException,
  }) async {
    if (latestOptions.isLatest) {
      final version = await _sdkService.getLatestSdk(
        channel: latestOptions.channel,
      );
      return call(
        version: version,
        latestOptions: (
          isLatest: false,
          channel: latestOptions.channel,
        ),
        isGlobal: isGlobal,
        throwUsageException: throwUsageException,
      );
    }

    final SdkVersion sdkVersion;
    if (version == null) {
      if (isGlobal) {
        final globalSdkVersion = _globalConfigService.findGlobalSdkVersion();
        if (globalSdkVersion == null) {
          throwUsageException(
            'Please specify a version or set a version in global config.',
          );
        }
        sdkVersion = globalSdkVersion;
      } else {
        final projectSdkVersion = _projectConfigService.findProjectSdkVersion();
        if (projectSdkVersion == null) {
          throwUsageException(
            'Please specify a version or set a version in project config.',
          );
        }
        sdkVersion = projectSdkVersion;
      }
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
          'Failed to install $sdkVersion.\n$e',
        );
        return ExitStatus.error;
      }
    }

    final updateSettingsProgress = _consoleService.progress(
      'Updating settings with Dart SDK version $sdkVersion',
    );
    try {
      if (isGlobal) {
        _globalConfigService.updateSettings(sdkVersion);
      } else {
        _projectConfigService.updateSettings(sdkVersion);
      }
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

typedef LatestOptions = ({
  bool isLatest,
  SdkChannel channel,
});

typedef ThrowUsageException = Never Function(String message);
