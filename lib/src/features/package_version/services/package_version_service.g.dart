// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'package_version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageVersionServiceHash() =>
    r'3803090c83761b5e3f1bbff18b048fa9ca449c44';

/// See also [packageVersionService].
@ProviderFor(packageVersionService)
final packageVersionServiceProvider =
    AutoDisposeProvider<PackageVersionService>.internal(
  packageVersionService,
  name: r'packageVersionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$packageVersionServiceHash,
  dependencies: <ProviderOrFamily>[cliInfoProvider, dvmClientProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    cliInfoProvider,
    ...?cliInfoProvider.allTransitiveDependencies,
    dvmClientProvider,
    ...?dvmClientProvider.allTransitiveDependencies
  },
);

typedef PackageVersionServiceRef
    = AutoDisposeProviderRef<PackageVersionService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
