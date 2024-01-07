// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sdkServiceHash() => r'de084142cc90cc99c4d82b1a62ff6352e6781e60';

/// See also [sdkService].
@ProviderFor(sdkService)
final sdkServiceProvider = AutoDisposeProvider<SdkService>.internal(
  sdkService,
  name: r'sdkServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sdkServiceHash,
  dependencies: <ProviderOrFamily>[dvmClientProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    dvmClientProvider,
    ...?dvmClientProvider.allTransitiveDependencies
  },
);

typedef SdkServiceRef = AutoDisposeProviderRef<SdkService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
