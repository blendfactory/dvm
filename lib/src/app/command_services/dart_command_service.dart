import 'package:dvm/src/app/models/exit_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dart_command_service.g.dart';

@Riverpod(
  dependencies: [],
)
DartCommandService dartCommandService(
  DartCommandServiceRef ref,
) {
  return DartCommandService();
}

final class DartCommandService {
  Future<ExitStatus> call({
    required List<String> args,
    required ThrowUsageException throwUsageException,
  }) async {
    if (args.firstOrNull == 'upgrade') {
      throwUsageException(
        'In dvm, the `dart upgrade` command is prohibited to avoid confusion.',
      );
    }

    return ExitStatus.success;
  }
}

typedef ThrowUsageException = Never Function(String message);
