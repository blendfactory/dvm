import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_system.g.dart';

@riverpod
FileSystem fileSystem(FileSystemRef ref) => const LocalFileSystem();
