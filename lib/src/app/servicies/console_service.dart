import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'console_service.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
ConsoleService consoleService(ConsoleServiceRef ref) {
  return const ConsoleService();
}

final class ConsoleService {
  const ConsoleService();

  void info(String message) => print(message);

  void warning(String message) => print('\x1B[33m$message\x1B[0m');

  void error(String message) {
    final msg = '''
An unexpected error occurred.
Consider creating an issue on https://github.com/blendfactory/dvm/issues/new.

$message''';
    print('\x1B[31m$msg\x1B[0m');
  }

  void spacer() => print('');
}
