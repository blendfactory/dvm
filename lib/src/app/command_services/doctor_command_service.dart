import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/app/servicies/package_service.dart';
import 'package:dvmx/src/features/global_config/services/global_config_service.dart';
import 'package:dvmx/src/features/project_config/services/project_config_service.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'doctor_command_service.g.dart';

@Riverpod(
  dependencies: [
    consoleService,
    packageService,
    sdkService,
    projectConfigService,
    globalConfigService,
  ],
)
DoctorCommandService doctorCommandService(
  DoctorCommandServiceRef ref,
) {
  final consoleService = ref.watch(consoleServiceProvider);
  final packageService = ref.watch(packageServiceProvider);
  final sdkService = ref.watch(sdkServiceProvider);
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final globalConfigService = ref.watch(globalConfigServiceProvider);
  return DoctorCommandService(
    consoleService: consoleService,
    packageService: packageService,
    sdkService: sdkService,
    projectConfigService: projectConfigService,
    globalConfigService: globalConfigService,
  );
}

final class DoctorCommandService {
  const DoctorCommandService({
    required ConsoleService consoleService,
    required PackageService packageService,
    required SdkService sdkService,
    required ProjectConfigService projectConfigService,
    required GlobalConfigService globalConfigService,
  })  : _consoleService = consoleService,
        _packageService = packageService,
        _sdkService = sdkService,
        _projectConfigService = projectConfigService,
        _globalConfigService = globalConfigService;

  final ConsoleService _consoleService;
  final PackageService _packageService;
  final SdkService _sdkService;
  final ProjectConfigService _projectConfigService;
  final GlobalConfigService _globalConfigService;

  Future<ExitStatus> call() async {
    return ExitStatus.success;
  }
}
