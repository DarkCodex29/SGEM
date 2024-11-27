import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permiso.g.dart';

@JsonSerializable()
class Permiso extends Equatable {
  const Permiso({
    this.key = -1,
    required this.name,
    required this.code,
    required this.userRegister,
    required this.dateRegister,
    this.activated = false,
  });

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
  final DateTime dateRegister;

  @JsonKey(name: 'Estado')
  final bool activated;

  Map<String, dynamic> toJson() => _$PermisoToJson(this);

  @override
  List<Object?> get props => [
        key,
        name,
        code,
        userRegister,
        dateRegister,
        activated,
      ];
}
