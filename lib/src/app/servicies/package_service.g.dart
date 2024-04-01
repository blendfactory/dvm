// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'package_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageServiceHash() => r'5efdfb45a0bab7b57891ed0cd436955a7cac7bdc';

/// See also [packageService].
@ProviderFor(packageService)
final packageServiceProvider = AutoDisposeProvider<PackageService>.internal(
  packageService,
  name: r'packageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$packageServiceHash,
  dependencies: <ProviderOrFamily>[dvmClientProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    dvmClientProvider,
    ...?dvmClientProvider.allTransitiveDependencies
  },
);

typedef PackageServiceRef = AutoDisposeProviderRef<PackageService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
