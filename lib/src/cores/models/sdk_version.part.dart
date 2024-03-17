part of 'sdk_version.dart';

final class _StableSdkVersion extends SdkVersion {
  const _StableSdkVersion({
    required super.major,
    required super.minor,
    required super.patch,
  });
}

sealed class _PreSdkVersion extends SdkVersion {
  const _PreSdkVersion({
    required super.major,
    required super.minor,
    required super.patch,
    required this.preMinor,
    required this.prePatch,
  });

  final int preMinor;
  final int prePatch;
}

final class _BetaSdkVersion extends _PreSdkVersion {
  const _BetaSdkVersion({
    required super.major,
    required super.minor,
    required super.patch,
    required super.preMinor,
    required super.prePatch,
  });
}

final class _DevSdkVersion extends _PreSdkVersion {
  const _DevSdkVersion({
    required super.major,
    required super.minor,
    required super.patch,
    required super.preMinor,
    required super.prePatch,
  });
}
