import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:riverpod/riverpod.dart';

final appContainer = ProviderContainer(
  overrides: [
    loggerProvider.overrideWithValue(Logger()),
  ],
);
