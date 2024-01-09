// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'install_command_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$installCommandServiceHash() =>
    r'c746cf6b2d029ae82b8f9de5b88900848a5381cd';

/// See also [installCommandService].
@ProviderFor(installCommandService)
final installCommandServiceProvider =
    AutoDisposeProvider<InstallCommandService>.internal(
  installCommandService,
  name: r'installCommandServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$installCommandServiceHash,
  dependencies: <ProviderOrFamily>{
    sdkServiceProvider,
    consoleServiceProvider,
    projectConfigServiceProvider,
    abiServiceProvider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    sdkServiceProvider,
    ...?sdkServiceProvider.allTransitiveDependencies,
    consoleServiceProvider,
    ...?consoleServiceProvider.allTransitiveDependencies,
    projectConfigServiceProvider,
    ...?projectConfigServiceProvider.allTransitiveDependencies,
    abiServiceProvider,
    ...?abiServiceProvider.allTransitiveDependencies
  },
);

typedef InstallCommandServiceRef
    = AutoDisposeProviderRef<InstallCommandService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
