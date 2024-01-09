import 'package:cli_util/cli_logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'console_service.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
external Logger logger(LoggerRef ref);

@Riverpod(
  keepAlive: true,
  dependencies: [
    logger,
  ],
)
ConsoleService consoleService(ConsoleServiceRef ref) {
  final logger = ref.watch(loggerProvider);
  return ConsoleService(
    logger: logger,
  );
}

final class ConsoleService {
  const ConsoleService({
    required Logger logger,
  }) : _logger = logger;

  final Logger _logger;

  void info(String message) => _logger.stdout(message);

  void warning(String message) {
    final ansi = _logger.ansi;
    final coloredMsg = '${ansi.yellow}$message${ansi.none}';
    _logger.stdout(coloredMsg);
  }

  void error(String message) {
    final msg = '''
An unexpected error occurred.
Consider creating an issue on https://github.com/blendfactory/dvm/issues/new.

$message''';
    _logger.stderr(msg);
  }

  void spacer() => _logger.stdout('');

  Progress progress(String message) => _logger.progress(message);
}
