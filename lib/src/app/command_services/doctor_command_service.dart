import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/features/global_config/services/global_config_service.dart';
import 'package:dvmx/src/features/package_version/services/package_version_service.dart';
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

    return ExitStatus.success;
  }
}
