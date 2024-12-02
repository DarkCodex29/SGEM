import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgem/shared/utils/model_converter.dart';

part 'permiso.g.dart';

@JsonSerializable()
class Permiso extends Equatable {
  Permiso({
    this.key = -1,
    required this.name,
    required this.code,
    required this.userRegister,
    DateTime? dateRegister,
    this.actived = false,
  }) : dateRegister = dateRegister ?? DateTime.now();

  factory Permiso.fromJson(Map<String, dynamic> json) =>
      _$PermisoFromJson(json);

  @JsonKey(name: 'Key')
  final int key;

  @JsonKey(name: 'Nombre')
  final String name;

  @JsonKey(name: 'Codigo')
  final String code;

  @JsonKey(name: 'UsuarioRegistro')
  final String userRegister;

  @JsonKey(name: 'FechaRegistro')
  @ajaxDateConverter
  final DateTime dateRegister;

  @JsonKey(name: 'Estado')
  @intBoolConverter
  final bool actived;

  Map<String, dynamic> toJson() => _$PermisoToJson(this);

  @override
  List<Object?> get props => [
        key,
        name,
        code,
        userRegister,
        dateRegister,
        actived,
      ];
}
