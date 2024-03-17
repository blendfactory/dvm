import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/app/servicies/dart_service.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/features/global_config/services/global_config_service.dart';
import 'package:dvmx/src/features/project_config/services/project_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dart_command_service.g.dart';

@Riverpod(
  dependencies: [
    projectConfigService,
    globalConfigService,
    dartService,
    consoleService,
  ],
)
DartCommandService dartCommandService(
  DartCommandServiceRef ref,
) {
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final globalConfigService = ref.watch(globalConfigServiceProvider);
  final dartService = ref.watch(dartServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  return DartCommandService(
    projectConfigService: projectConfigService,
    globalConfigService: globalConfigService,
    dartService: dartService,
    consoleService: consoleService,
  );
}

final class DartCommandService {
  DartCommandService({
    required ProjectConfigService projectConfigService,
    required GlobalConfigService globalConfigService,
    required DartService dartService,
    required ConsoleService consoleService,
  })  : _projectConfigService = projectConfigService,
        _globalConfigService = globalConfigService,
        _dartService = dartService,
        _consoleService = consoleService;

  final ProjectConfigService _projectConfigService;
  final GlobalConfigService _globalConfigService;
  final DartService _dartService;
  final ConsoleService _consoleService;

  Future<ExitStatus> call({
    required List<String> args,
    required ThrowUsageException throwUsageException,
  }) async {
    if (args.firstOrNull == 'upgrade') {
      throwUsageException(
        'In dvm, the `dart upgrade` command is prohibited to avoid confusion.',
      );
    }

    final SdkVersion? sdkVersion;
    final projectSdkVersion = _projectConfigService.findProjectSdkVersion();
    if (projectSdkVersion == null) {
      sdkVersion = _globalConfigService.findGlobalSdkVersion();
    } else {
      sdkVersion = projectSdkVersion;
    }

    if (sdkVersion == null) {
      throwUsageException(
        'Please set a version in project or global config.',
      );
    }

    final result = await _dartService.runWithVersion(
      version: sdkVersion,
      args: args,
    );

    final infoMessage = result.stdout as String?;
    if (infoMessage != null && infoMessage.isNotEmpty) {
      _consoleService.info(infoMessage.trimRight());
    }

    final exitStatus = ExitStatus.fromCode(result.exitCode);

    final errorMessage = result.stderr as String?;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      if (exitStatus case ExitStatus.success || ExitStatus.usage) {
        _consoleService.info(errorMessage.trimRight());
      } else {
        _consoleService.error(errorMessage.trimRight());
      }
    }
    return exitStatus;
  }
}

typedef ThrowUsageException = Never Function(String message);
