import 'package:dvmx/src/cores/local/development_dir.dart';
import 'package:dvmx/src/cores/local/file_system.dart';
import 'package:dvmx/src/cores/local/is_debug.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_root_dir.g.dart';

@Riverpod(
  dependencies: [
    isDebug,
    developmentDir,
    fileSystem,
  ],
)
Directory projectRootDir(ProjectRootDirRef ref) {
  final isDebug = ref.watch(isDebugProvider);
  final developmentDir = ref.watch(developmentDirProvider);
  final fileSystem = ref.watch(fileSystemProvider);

  if (isDebug) {
    return developmentDir.childDirectory('project');
  } else {
    return fileSystem.currentDirectory;
  }
}
