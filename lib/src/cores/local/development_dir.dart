import 'package:dvmx/src/cores/local/file_system.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'development_dir.g.dart';

@Riverpod(
  dependencies: [
    fileSystem,
  ],
)
Directory developmentDir(DevelopmentDirRef ref) {
  final fileSystem = ref.watch(fileSystemProvider);
  return fileSystem.currentDirectory.childDirectory('.development');
}
