import 'dart:io';

import 'package:dvm/dvm.dart';

Future<void> main(List<String> args) async {
  final commandRunner = DvmCommandRunner();
  final exitStatus = await commandRunner.run(args);
  await exitStatus.flushThenExit();
}

extension _FlushThenExit on ExitStatus {
  Future<void> flushThenExit() async => Future.wait(
        [
          stdout.close(),
          stderr.close(),
        ],
      ).then(
        (_) => exit(code),
      );
}
