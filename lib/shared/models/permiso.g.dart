// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permiso.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permiso _$PermisoFromJson(Map<String, dynamic> json) => Permiso(
      key: (json['Key'] as num?)?.toInt() ?? -1,
      name: json['Nombre'] as String,
      code: json['Codigo'] as String,
      userRegister: json['UsuarioRegistro'] as String,
      dateRegister: ajaxDateConverter.fromJson(json['FechaRegistro'] as String),
      actived: json['Estado'] == null
          ? false
          : intBoolConverter.fromJson((json['Estado'] as num).toInt()),
    );

Map<String, dynamic> _$PermisoToJson(Permiso instance) => <String, dynamic>{
      'Key': instance.key,
      'Nombre': instance.name,
      'Codigo': instance.code,
      'UsuarioRegistro': instance.userRegister,
      'FechaRegistro': ajaxDateConverter.toJson(instance.dateRegister),
      'Estado': intBoolConverter.toJson(instance.actived),
    };
