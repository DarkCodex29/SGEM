// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modulo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modulo _$ModuloFromJson(Map<String, dynamic> json) => Modulo(
      key: (json['Key'] as num).toInt(),
      module: json['Modulo'] as String,
      hours: (json['InHours'] as num).toInt(),
      minGrade: (json['InNotaMinima'] as num).toInt(),
      maxGrade: (json['InNotaMaxima'] as num).toInt(),
      status: json['InEstado'] as bool,
      userModification: json['UsuarioModificacion'] as String,
      modificationDate: _$JsonConverterFromJson<String, DateTime>(
          json['FechaModificacion'], ajaxDateConverter.fromJson),
    );

Map<String, dynamic> _$ModuloToJson(Modulo instance) => <String, dynamic>{
      'Key': instance.key,
      'Modulo': instance.module,
      'InHours': instance.hours,
      'InNotaMinima': instance.minGrade,
      'InNotaMaxima': instance.maxGrade,
      'InEstado': instance.status,
      'UsuarioModificacion': instance.userModification,
      'FechaModificacion': _$JsonConverterToJson<String, DateTime>(
          instance.modificationDate, ajaxDateConverter.toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
