import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/abi_service.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/features/project_config/services/project_config_service.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'install_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
    projectConfigService,
    abiService,
  ],
)
InstallCommandService installCommandService(
  InstallCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final abiService = ref.watch(abiServiceProvider);
  return InstallCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
    projectConfigService: projectConfigService,
    abiService: abiService,
  );
}

final class InstallCommandService {
  const InstallCommandService({
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
    required LatestOptions latestOptions,
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
        throwUsageException: throwUsageException,
      );
    }

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
    if (existsSdk) {
      _consoleService.warning('Already installed $sdkVersion.');
      return ExitStatus.success;
    }

    final (os: os, arch: arch) = _abiService.getOsAndArch();

    final installProgress = _consoleService.progress('Installing $sdkVersion');
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
    return ExitStatus.success;
  }
}

typedef LatestOptions = ({
  bool isLatest,
  SdkChannel channel,
});

typedef ThrowUsageException = Never Function(String message);
