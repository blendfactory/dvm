import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:dvmx/src/app/gen/cli_info.g.dart';
import 'package:grinder/grinder.dart';

Future<void> main(List<String> args) async {
  pkg.name.value = cliInfo.name;

  pkg.addGithubTasks();

  await grind(args);
}
