import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_debug.g.dart';

@riverpod
// ignore: do_not_use_environment
bool isDebug(IsDebugRef ref) => const bool.fromEnvironment('DEBUG');
