// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'global_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalConfig _$GlobalConfigFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GlobalConfig',
      json,
      ($checkedConvert) {
        final val = GlobalConfig(
          version:
              $checkedConvert('dartSdkVersion', (v) => _fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'version': 'dartSdkVersion'},
    );

Map<String, dynamic> _$GlobalConfigToJson(GlobalConfig instance) =>
    <String, dynamic>{
      'dartSdkVersion': _toJson(instance.version),
    };
