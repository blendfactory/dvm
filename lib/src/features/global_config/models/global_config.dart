import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:json_annotation/json_annotation.dart';

part 'global_config.g.dart';

@JsonSerializable()
final class GlobalConfig {
  const GlobalConfig({
    required this.version,
  });

  factory GlobalConfig.fromJson(Map<String, dynamic> json) =>
      _$GlobalConfigFromJson(json);

  @JsonKey(
    name: 'dartSdkVersion',
    toJson: _toJson,
    fromJson: _fromJson,
  )
  final SdkVersion version;

  Map<String, dynamic> toJson() => _$GlobalConfigToJson(this);
}

String _toJson(SdkVersion value) => value.toString();
SdkVersion _fromJson(String value) => SdkVersion.fromString(value);
