import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:dvmx/src/app/gen/cli_info.dart';
import 'package:grinder/grinder.dart';

import 'checksum.dart';

const _githubUser = 'blendthink';
const _githubRepo = 'blendfactory/dvm';

Future<void> main(List<String> args) async {
  if (args.firstOrNull == 'pkg-version') {
    // ignore: avoid_print
    print(cliInfo.version);
    return;
  }

  pkg.name.value = cliInfo.name;
  pkg.githubUser.value = _githubUser;
  pkg.githubRepo.value = _githubRepo;

  pkg.addGithubTasks();

  addChecksumTasks();

  await grind(args);
}
