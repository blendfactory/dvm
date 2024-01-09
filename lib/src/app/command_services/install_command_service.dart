import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/app/servicies/console_service.dart';
import 'package:dvm/src/features/project_config/services/project_config_service.dart';
import 'package:dvm/src/features/sdk/models/sdk_version.dart';
import 'package:dvm/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'install_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
    projectConfigService,
  ],
)
InstallCommandService installCommandService(
  InstallCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  return InstallCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
    projectConfigService: projectConfigService,
  );
}

final class InstallCommandService {
  const InstallCommandService({
    required ConsoleService consoleService,
    required SdkService sdkService,
    required ProjectConfigService projectConfigService,
  })  : _consoleService = consoleService,
        _sdkService = sdkService,
        _projectConfigService = projectConfigService;

  final ConsoleService _consoleService;
  final SdkService _sdkService;
  final ProjectConfigService _projectConfigService;

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
    if (existsSdk) {
      _consoleService.warning('Already installed $sdkVersion.');
      return ExitStatus.success;
    }

    final installProgress = _consoleService.progress('Installing $sdkVersion');
    await _sdkService.installSdk(version: sdkVersion);
    installProgress.finish(message: 'Installed $sdkVersion.');

    final activateProgress = _consoleService.progress('Activating $sdkVersion');
    await _sdkService.activateSdk(version: sdkVersion);
    activateProgress.finish(message: 'Activated $sdkVersion.');

    return ExitStatus.success;
  }
}

typedef ThrowUsageException = Never Function(String message);
