import 'dart:io';

import 'package:dvm/src/data/exit_status.dart';

int calculate() {
  return 6 * 7;
}

extension FlushThenExit on ExitStatus {
  Future<void> flushThenExit() async => Future.wait(
        [
          stdout.close(),
          stderr.close(),
        ],
      ).then(
        (_) => exit(code),
      );
}
