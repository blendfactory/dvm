import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'console_service.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
ConsoleService consoleService(ConsoleServiceRef ref) {
  return const ConsoleService();
}

final class ConsoleService {
  const ConsoleService();

  void info(String message) => print(message);
}
