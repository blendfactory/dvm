import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:meta/meta.dart';

part 'sdk_version.part.dart';

/// See https://dart.dev/get-dart#release-channels
///
/// Stable channel releases of the Dart SDK have x.y.z version strings like
/// 1.24.3 and 2.1.0. They consist of dot-separated integers, with no hyphens or
/// letters, where x is the major version, y is the minor version, and z is
/// the patch version.
///
/// Beta and dev channel releases of the Dart SDK (non-stable releases) have
/// x.y.z-a.b.<beta|dev> versions like 2.8.0-20.11.beta. The part before
/// the hyphen follows the stable version scheme, a and b after the hyphen are
/// the prerelease and prerelease patch versions, and beta or dev is
/// the channel.
@immutable
sealed class SdkVersion implements Comparable<SdkVersion> {
  const SdkVersion({
    required this.major,
    required this.minor,
    required this.patch,
  });

  factory SdkVersion.fromString(String value) {
    const nameMajor = 'major';
    const nameMinor = 'minor';
    const namePatch = 'patch';
    const namePreMinor = 'pre_minor';
    const namePrePatch = 'pre_patch';
    const nameChannel = 'channel';

    final regex = RegExp(
      '''^(?<$nameMajor>\\d+)\\.(?<$nameMinor>\\d+)\\.(?<$namePatch>\\d+)(-(?<$namePreMinor>\\d+)\\.(?<$namePrePatch>\\d+)\\.(?<$nameChannel>beta|dev))?\$''',
    );
    final match = regex.firstMatch(value);
    if (match == null) {
      throw FormatException('Invalid Dart SDK version: $value');
    }

    final major = int.parse(match.namedGroup(nameMajor)!);
    final minor = int.parse(match.namedGroup(nameMinor)!);
    final patch = int.parse(match.namedGroup(namePatch)!);

    final channelName = match.namedGroup(nameChannel) ?? 'stable';
    final channel = SdkChannel.values.byName(channelName);
    if (channel == SdkChannel.stable) {
      return SdkVersion.stable(
        major: major,
        minor: minor,
        patch: patch,
      );
    }

    final preMinor = int.parse(match.namedGroup(namePreMinor)!);
    final prePatch = int.parse(match.namedGroup(namePrePatch)!);
    if (channel == SdkChannel.beta) {
      return SdkVersion.beta(
        major: major,
        minor: minor,
        patch: patch,
        preMinor: preMinor,
        prePatch: prePatch,
      );
    } else {
      return SdkVersion.dev(
        major: major,
        minor: minor,
        patch: patch,
        preMinor: preMinor,
        prePatch: prePatch,
      );
    }
  }

  factory SdkVersion.stable({
    required int major,
    required int minor,
    required int patch,
  }) = _StableSdkVersion;

  factory SdkVersion.beta({
    required int major,
    required int minor,
    required int patch,
    required int preMinor,
    required int prePatch,
  }) = _BetaSdkVersion;

  factory SdkVersion.dev({
    required int major,
    required int minor,
    required int patch,
    required int preMinor,
    required int prePatch,
  }) = _DevSdkVersion;

  final int major;
  final int minor;
  final int patch;

  @override
  String toString() {
    final baseVersion = '$major.$minor.$patch';
    return switch (this) {
      final _StableSdkVersion _ => baseVersion,
      final _PreSdkVersion p => () {
          final channel = switch (p) {
            final _BetaSdkVersion _ => 'beta',
            final _DevSdkVersion _ => 'dev',
          };
          return '''$baseVersion-${p.preMinor}.${p.prePatch}.$channel''';
        }(),
    };
  }

  @override
  bool operator ==(Object other) => switch (this) {
        final _StableSdkVersion s => other is _StableSdkVersion &&
            s.runtimeType == other.runtimeType &&
            s.major == other.major &&
            s.minor == other.minor &&
            s.patch == other.patch,
        final _BetaSdkVersion b => other is _BetaSdkVersion &&
            b.runtimeType == other.runtimeType &&
            b.major == other.major &&
            b.minor == other.minor &&
            b.patch == other.patch &&
            b.preMinor == other.preMinor &&
            b.prePatch == other.prePatch,
        final _DevSdkVersion d => other is _DevSdkVersion &&
            d.runtimeType == other.runtimeType &&
            d.major == other.major &&
            d.minor == other.minor &&
            d.patch == other.patch &&
            d.preMinor == other.preMinor &&
            d.prePatch == other.prePatch,
      };

  @override
  int get hashCode => switch (this) {
        final _StableSdkVersion s => Object.hash(
            s.runtimeType,
            s.major,
            s.minor,
            s.patch,
          ),
        final _BetaSdkVersion b => Object.hash(
            b.runtimeType,
            b.major,
            b.minor,
            b.patch,
            b.preMinor,
            b.prePatch,
          ),
        final _DevSdkVersion d => Object.hash(
            d.runtimeType,
            d.major,
            d.minor,
            d.patch,
            d.preMinor,
            d.prePatch,
          ),
      };

  @override
  int compareTo(SdkVersion other) {
    final majorCompare = major.compareTo(other.major);
    if (majorCompare != 0) {
      return majorCompare;
    }

    final minorCompare = minor.compareTo(other.minor);
    if (minorCompare != 0) {
      return minorCompare;
    }

    final patchCompare = patch.compareTo(other.patch);
    if (patchCompare != 0) {
      return patchCompare;
    }

    return switch (this) {
      final _StableSdkVersion _ => switch (other) {
          final _StableSdkVersion _ => 0,
          final _PreSdkVersion _ => -1,
        },
      final _PreSdkVersion p => switch (other) {
          final _StableSdkVersion _ => 1,
          final _PreSdkVersion o => () {
              final preMinorCompare = p.preMinor.compareTo(o.preMinor);
              if (preMinorCompare != 0) {
                return preMinorCompare;
              }

              final prePatchCompare = p.prePatch.compareTo(o.prePatch);
              if (prePatchCompare != 0) {
                return prePatchCompare;
              }

              return switch (p) {
                final _BetaSdkVersion _ => switch (o) {
                    final _BetaSdkVersion _ => 0,
                    final _DevSdkVersion _ => 1,
                  },
                final _DevSdkVersion _ => switch (o) {
                    final _BetaSdkVersion _ => -1,
                    final _DevSdkVersion _ => 0,
                  },
              };
            }(),
        },
    };
  }

  bool operator <(SdkVersion other) => compareTo(other) < 0;
  bool operator >(SdkVersion other) => compareTo(other) > 0;
  bool operator <=(SdkVersion other) => compareTo(other) <= 0;
  bool operator >=(SdkVersion other) => compareTo(other) >= 0;

  SdkChannel get channel => switch (this) {
        final _StableSdkVersion _ => SdkChannel.stable,
        final _BetaSdkVersion _ => SdkChannel.beta,
        final _DevSdkVersion _ => SdkChannel.dev,
      };
}
