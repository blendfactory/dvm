// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'system_temp_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$systemTempDirHash() => r'ba59b551e9881b4efd985f137ef1df6fd566ca49';

/// See also [systemTempDir].
@ProviderFor(systemTempDir)
final systemTempDirProvider = AutoDisposeProvider<Directory>.internal(
  systemTempDir,
  name: r'systemTempDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$systemTempDirHash,
  dependencies: <ProviderOrFamily>[fileSystemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef SystemTempDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
