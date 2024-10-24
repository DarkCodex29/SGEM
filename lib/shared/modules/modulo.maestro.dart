import 'dart:convert';

import 'package:sgem/shared/widgets/dropDown/custom.dropdown.dart';

List<ModuloMaestro> moduloMaestroFromJson(String str) =>
    List<ModuloMaestro>.from(
        json.decode(str).map((x) => ModuloMaestro.fromJson(x)));

String moduloMaestroToJson(List<ModuloMaestro> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuloMaestro implements DropdownElement {
  int key;
  String? modulo;
  int? inHoras;
  int? inNotaMinima;
  int? inNotaMaxima;
  int? inEstado;
  String? usuarioModificacion;
  DateTime? fechaModificacion;
  int? orden;

  @override
  String get value => modulo ?? "none";

  @override
  int get id => key;

  ModuloMaestro({
    required this.key,
    this.modulo,
    this.inHoras,
    this.inNotaMinima,
    this.inNotaMaxima,
    this.inEstado,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.orden,
  });

  factory ModuloMaestro.fromJson(Map<String, dynamic> json) => ModuloMaestro(
        key: json["Key"],
        modulo: json["Modulo"],
        inHoras: json["InHoras"],
        inNotaMinima: json["InNotaMinima"],
        inNotaMaxima: json["InNotaMaxima"],
        inEstado: json["InEstado"],
        usuarioModificacion: json["UsuarioModificacion"],
        fechaModificacion: json["FechaModificacion"] != null
            ? _fromDotNetDate(json["FechaModificacion"])
            : null,
        orden: json["Orden"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "Modulo": modulo,
        "InHoras": inHoras,
        "InNotaMinima": inNotaMinima,
        "InNotaMaxima": inNotaMaxima,
        "InEstado": inEstado,
        "UsuarioModificacion": usuarioModificacion,
        "FechaModificacion": fechaModificacion != null
            ? _toDotNetDate(fechaModificacion!)
            : null,
        "Orden": orden,
      };

  // Método para deserializar la fecha en formato .NET
  static DateTime _fromDotNetDate(String dotNetDate) {
    final milliseconds = int.parse(dotNetDate.replaceAll(RegExp(r'[^\d]'), ''));
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  // Método para serializar la fecha de vuelta al formato .NET
  static String _toDotNetDate(DateTime date) {
    return '/Date(${date.millisecondsSinceEpoch})/';
  }
}
