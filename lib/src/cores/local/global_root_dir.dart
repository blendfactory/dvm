import 'package:dvmx/src/cores/local/development_dir.dart';
import 'package:dvmx/src/cores/local/dvm_home_dir.dart';
import 'package:dvmx/src/cores/local/is_debug.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_root_dir.g.dart';

@Riverpod(
  dependencies: [
    isDebug,
    developmentDir,
    dvmHomeDir,
  ],
)
Directory globalRootDir(GlobalRootDirRef ref) {
  final isDebug = ref.watch(isDebugProvider);
  final developmentDir = ref.watch(developmentDirProvider);
  final dvmHomeDir = ref.watch(dvmHomeDirProvider);

  if (isDebug) {
    return developmentDir;
  } else {
    return dvmHomeDir;
  }
}
