import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/features/sdk/models/sdk_version.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uninstall_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
  ],
)
UninstallCommandService uninstallCommandService(
  UninstallCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  return UninstallCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
  );
}

final class UninstallCommandService {
  UninstallCommandService({
    required SdkService sdkService,
    required ConsoleService consoleService,
  })  : _sdkService = sdkService,
        _consoleService = consoleService;

  final SdkService _sdkService;
  final ConsoleService _consoleService;

  Future<ExitStatus> call({
    bool isAll = false,
    SdkVersion? version,
  }) async {
    if (isAll) {
      final progress = _consoleService.progress('Uninstalling all SDKs');
      try {
        await _sdkService.uninstallAllSdks();
        progress.complete('Uninstalled all SDKs.');
        return ExitStatus.success;
      } on Exception catch (e) {
        progress.fail(
          'Failed to uninstall all SDKs.\n$e',
        );
        return ExitStatus.error;
      }
    }

    final versions = await _sdkService.getInstalledSdks(channel: null);
    final SdkVersion uninstallVersion;
    if (version == null) {
      if (versions.isEmpty) {
        _consoleService.warning('No SDKs installed.');
        return ExitStatus.success;
      }
      uninstallVersion = _consoleService.chooseOne(
        message: 'Select a version to uninstall',
        choices: versions,
      );
    } else {
      if (!versions.contains(version)) {
        _consoleService.warning('No such version installed: $version.');
        return ExitStatus.success;
      }
      uninstallVersion = version;
    }

    final progress = _consoleService.progress('Uninstalling $uninstallVersion');
    try {
      await _sdkService.uninstallSdk(version: uninstallVersion);
      progress.complete('Uninstalled $uninstallVersion.');
      return ExitStatus.success;
    } on Exception catch (e) {
      progress.fail(
        'Failed to uninstall $uninstallVersion.\n$e',
      );
      return ExitStatus.error;
    }
  }
}
