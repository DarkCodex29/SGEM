import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgem/shared/utils/model_converter.dart';

part 'rol.g.dart';

@JsonSerializable()
class Rol extends Equatable {
  const Rol({
    this.key = -1,
    required this.name,
    required this.dateRegister,
    required this.userRegister,
    this.actived = false,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => _$RolFromJson(json);

  @JsonKey(name: 'Key')
  final int key;

  @JsonKey(name: 'Nombre')
  final String name;

  @JsonKey(name: 'UsuarioRegistro')
  final String userRegister;

  @JsonKey(name: 'FechaRegistro')
  @ajaxDateConverter
  final DateTime dateRegister;

  @JsonKey(name: 'Estado')
  @intBoolConverter
  final bool actived;

  Map<String, dynamic> toJson() => _$RolToJson(this);

  @override
  List<Object?> get props => [
        key,
        name,
        userRegister,
        dateRegister,
        actived,
      ];
}
