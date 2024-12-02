// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rol _$RolFromJson(Map<String, dynamic> json) => Rol(
      key: (json['Key'] as num?)?.toInt() ?? -1,
      name: json['Nombre'] as String,
      dateRegister: ajaxDateConverter.fromJson(json['FechaRegistro'] as String),
      userRegister: json['UsuarioRegistro'] as String,
      actived: json['Estado'] == null
          ? false
          : intBoolConverter.fromJson((json['Estado'] as num).toInt()),
    );

Map<String, dynamic> _$RolToJson(Rol instance) => <String, dynamic>{
      'Key': instance.key,
      'Nombre': instance.name,
      'UsuarioRegistro': instance.userRegister,
      'FechaRegistro': ajaxDateConverter.toJson(instance.dateRegister),
      'Estado': intBoolConverter.toJson(instance.actived),
    };
