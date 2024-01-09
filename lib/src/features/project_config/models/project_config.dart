import 'package:dvm/src/features/sdk/models/sdk_version.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_config.g.dart';

@JsonSerializable()
final class ProjectConfig {
  const ProjectConfig({
    required this.version,
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);

  @JsonKey(
    name: 'dartSdkVersion',
    toJson: _toJson,
    fromJson: _fromJson,
  )
  final SdkVersion version;

  Map<String, dynamic> toJson() => _$ProjectConfigToJson(this);
}

String _toJson(SdkVersion value) => value.toString();
SdkVersion _fromJson(String value) => SdkVersion.fromString(value);
