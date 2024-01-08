import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dvm/src/app/models/exit_status.dart';

abstract class AppCommand extends Command<ExitStatus> {
  @override
  ArgResults get argResults =>
      super.argResults ??
      (throw ArgumentError.notNull(
        '''`argResults` cannn't be used before `run()` method is called.''',
      ));
}
