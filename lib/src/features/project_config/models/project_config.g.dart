// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'project_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectConfig _$ProjectConfigFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProjectConfig',
      json,
      ($checkedConvert) {
        final val = ProjectConfig(
          version:
              $checkedConvert('dartSdkVersion', (v) => _fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'version': 'dartSdkVersion'},
    );

Map<String, dynamic> _$ProjectConfigToJson(ProjectConfig instance) =>
    <String, dynamic>{
      'dartSdkVersion': _toJson(instance.version),
    };
