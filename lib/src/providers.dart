import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
// ignore: do_not_use_environment
bool isDebug(IsDebugRef ref) => const bool.fromEnvironment('DEBUG');

@riverpod
FileSystem fileSystem(FileSystemRef ref) => const LocalFileSystem();

@riverpod
Directory projectConfigDir(ProjectConfigDirRef ref) {
  final isDebug = ref.watch(isDebugProvider);
  final fileSystem = ref.watch(fileSystemProvider);
  final projectConfigDirName = isDebug ? '.build' : '.dvm';
  return fileSystem.currentDirectory.childDirectory(projectConfigDirName);
}
