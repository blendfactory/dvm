// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'dart_command_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dartCommandServiceHash() =>
    r'427f70548b3f4f36e32742b3565e490b8c931d25';

/// See also [dartCommandService].
@ProviderFor(dartCommandService)
final dartCommandServiceProvider =
    AutoDisposeProvider<DartCommandService>.internal(
  dartCommandService,
  name: r'dartCommandServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dartCommandServiceHash,
  dependencies: <ProviderOrFamily>{
    projectConfigServiceProvider,
    globalConfigServiceProvider,
    dartServiceProvider,
    consoleServiceProvider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    projectConfigServiceProvider,
    ...?projectConfigServiceProvider.allTransitiveDependencies,
    globalConfigServiceProvider,
    ...?globalConfigServiceProvider.allTransitiveDependencies,
    dartServiceProvider,
    ...?dartServiceProvider.allTransitiveDependencies,
    consoleServiceProvider,
    ...?consoleServiceProvider.allTransitiveDependencies
  },
);

typedef DartCommandServiceRef = AutoDisposeProviderRef<DartCommandService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
