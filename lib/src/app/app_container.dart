import 'package:dvmx/src/app/gen/cli_info.dart' as gen;
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/cores/local/cli_info.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:riverpod/riverpod.dart';

final appContainer = ProviderContainer(
  overrides: [
    loggerProvider.overrideWithValue(Logger()),
    cliInfoProvider.overrideWithValue(gen.cliInfo),
  ],
);
