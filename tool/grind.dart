import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:dvmx/src/app/gen/cli_info.g.dart';
import 'package:grinder/grinder.dart';

const _githubUser = 'blendthink';
const _githubRepo = 'blendfactory/dvm';

Future<void> main(List<String> args) async {
  pkg.name.value = cliInfo.name;
  pkg.githubUser.value = _githubUser;
  pkg.githubRepo.value = _githubRepo;

  pkg.addGithubTasks();

  await grind(args);
}
