// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permiso.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permiso _$PermisoFromJson(Map<String, dynamic> json) => Permiso(
      key: (json['Key'] as num?)?.toInt() ?? -1,
      name: json['Nombre'] as String,
      codigo: json['Codigo'] as String,
      userRegister: json['UsuarioRegistro'] as String,
      dateRegister: DateTime.parse(json['FechaRegistro'] as String),
      activated: json['Estado'] as bool? ?? false,
    );

Map<String, dynamic> _$PermisoToJson(Permiso instance) => <String, dynamic>{
      'Key': instance.key,
      'Nombre': instance.name,
      'Codigo': instance.codigo,
      'UsuarioRegistro': instance.userRegister,
      'FechaRegistro': instance.dateRegister.toIso8601String(),
      'Estado': instance.activated,
    };
