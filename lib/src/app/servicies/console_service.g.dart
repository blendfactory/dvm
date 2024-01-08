// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loggerHash() => r'571fd74e6411c781a6ba8e381c80f3e9673abaee';

/// See also [logger].
@ProviderFor(logger)
final loggerProvider = Provider<Logger>.internal(
  (_) => throw UnsupportedError(
    'The provider "loggerProvider" is expected to get overridden/scoped, '
    'but was accessed without an override.',
  ),
  name: r'loggerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loggerHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef LoggerRef = ProviderRef<Logger>;
String _$consoleServiceHash() => r'9251842135f4dac03f2156f7ea155025d501229f';

/// See also [consoleService].
@ProviderFor(consoleService)
final consoleServiceProvider = Provider<ConsoleService>.internal(
  consoleService,
  name: r'consoleServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consoleServiceHash,
  dependencies: <ProviderOrFamily>[loggerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    loggerProvider,
    ...?loggerProvider.allTransitiveDependencies
  },
);

typedef ConsoleServiceRef = ProviderRef<ConsoleService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
