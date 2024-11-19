import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgem/shared/utils/model_converter.dart';

part 'modulo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Modulo extends Equatable {
  const Modulo({
    required this.key,
    required this.module,
    required this.hours,
    required this.minGrade,
    required this.maxGrade,
    required this.status,
    required this.userModification,
    required this.modificationDate,
  });

  factory Modulo.fromJson(Map<String, dynamic> json) => _$ModuloFromJson(json);

  final int key;

  @JsonKey(name: 'Modulo')
  final String module;

  @JsonKey(name: 'InHours')
  final int hours;

  @JsonKey(name: 'InNotaMinima')
  final int minGrade;

  @JsonKey(name: 'InNotaMaxima')
  final int maxGrade;

  @intBoolConverter
  @JsonKey(name: 'InEstado')
  final bool status;

  @JsonKey(name: 'UsuarioModificacion')
  final String userModification;

  @ajaxDateConverter
  @JsonKey(name: 'FechaModificacion')
  final DateTime? modificationDate;

  Map<String, dynamic> toJson() => _$ModuloToJson(this);

  Modulo copyWith({
    int? key,
    String? module,
    int? hours,
    int? minGrade,
    int? maxGrade,
    bool? status,
    String? userModification,
    DateTime? modificationDate,
  }) {
    return Modulo(
      key: key ?? this.key,
      module: module ?? this.module,
      hours: hours ?? this.hours,
      minGrade: minGrade ?? this.minGrade,
      maxGrade: maxGrade ?? this.maxGrade,
      status: status ?? this.status,
      userModification: userModification ?? this.userModification,
      modificationDate: modificationDate ?? this.modificationDate,
    );
  }

  @override
  List<Object> get props => [key];
}

