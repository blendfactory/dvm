import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/app/servicies/console_service.dart';
import 'package:dvm/src/app/servicies/dart_service.dart';
import 'package:dvm/src/features/project_config/services/project_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dart_command_service.g.dart';

@Riverpod(
  dependencies: [
    projectConfigService,
    dartService,
    consoleService,
  ],
)
DartCommandService dartCommandService(
  DartCommandServiceRef ref,
) {
  final projectConfigService = ref.watch(projectConfigServiceProvider);
  final dartService = ref.watch(dartServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  return DartCommandService(
    projectConfigService: projectConfigService,
    dartService: dartService,
    consoleService: consoleService,
  );
}

final class DartCommandService {
  DartCommandService({
    required ProjectConfigService projectConfigService,
    required DartService dartService,
    required ConsoleService consoleService,
  })  : _projectConfigService = projectConfigService,
        _dartService = dartService,
        _consoleService = consoleService;

  final ProjectConfigService _projectConfigService;
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

    final sdkVersion = _projectConfigService.findProjectSdkVersion();
    if (sdkVersion == null) {
      throwUsageException(
        'Please set a version in project config.',
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
