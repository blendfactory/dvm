import 'package:cli_util/cli_logging.dart';
import 'package:dvm/src/app/servicies/console_service.dart';
import 'package:riverpod/riverpod.dart';

final appContainer = ProviderContainer(
  overrides: [
    loggerProvider.overrideWithValue(Logger.standard()),
  ],
);
