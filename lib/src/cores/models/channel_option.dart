import 'package:collection/collection.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';

sealed class ChannelOption {
  const ChannelOption();

  String get value;

  SdkChannel? toSdkChannelOrNull() {
    if (this is SdkChannelOption) {
      return (this as SdkChannelOption).channel;
    }
    return null;
  }

  static ChannelOption byValue(String value) {
    final option = options.firstWhereOrNull(
      (option) => option.value == value,
    );
    if (option == null) {
      throw ArgumentError.value(value, 'value', 'Unknown channel option.');
    }
    return option;
  }

  static const List<ChannelOption> options = [all, stable, beta, dev];

  static const ChannelOption all = _AllChannelOption();
  static const ChannelOption stable = _StableChannelOption();
  static const ChannelOption beta = _BetaChannelOption();
  static const ChannelOption dev = _DevChannelOption();
}

final class _AllChannelOption extends ChannelOption {
  const _AllChannelOption();

  @override
  String get value => 'all';
}

sealed class SdkChannelOption extends ChannelOption {
  const SdkChannelOption(this.channel);

  final SdkChannel channel;

  @override
  String get value => channel.name;
}

final class _StableChannelOption extends SdkChannelOption {
  const _StableChannelOption() : super(SdkChannel.stable);
}

final class _BetaChannelOption extends SdkChannelOption {
  const _BetaChannelOption() : super(SdkChannel.beta);
}

final class _DevChannelOption extends SdkChannelOption {
  const _DevChannelOption() : super(SdkChannel.dev);
}
