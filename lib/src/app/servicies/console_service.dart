import 'package:dvmx/src/app/models/check_status.dart';
import 'package:mason_logger/mason_logger.dart';
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

  void info(String message) => _logger.info(message);

  void warning(String message) => _logger.warn(message);

  void error(String message) {
    final issueLink = link(
      message: 'GitHub Issue',
      uri: Uri.parse('https://github.com/blendfactory/dvm/issues/new'),
    );
    final msg = '''
An unexpected error occurred.
Consider creating an issue on $issueLink.

$message''';
    _logger.err(msg);
  }

  void spacer() => _logger.info('');

  Progress progress(String message) => _logger.progress(message);

  bool confirm(
    String message, {
    bool defaultValue = true,
  }) =>
      _logger.confirm(
        message,
        defaultValue: defaultValue,
      );

  T chooseOne<T>({
    required String message,
    required List<T> choices,
  }) =>
      _logger.chooseOne(
        message,
        choices: choices,
      );

  void checkResult(CheckResult result) {
    final tag = switch (result.status) {
      CheckStatus.success => lightGreen.wrap('[✓]'),
      CheckStatus.warning => lightYellow.wrap('[!]'),
      CheckStatus.error => lightRed.wrap('[✗]'),
    };
    _logger.info('$tag ${result.summary}');

    if (result.detail case final String detail) {
      final detailLines = detail.split('\n');
      const indent = '    ';
      for (final detailLine in detailLines) {
        _logger.detail('$indent$detailLine');
      }
    }
  }
}

typedef CheckResult = ({
  CheckStatus status,
  String summary,
  String? detail,
});
