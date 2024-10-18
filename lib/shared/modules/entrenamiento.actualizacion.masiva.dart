// To parse this JSON data, do
//
//     final entrenamientoActualizacionMasiva = entrenamientoActualizacionMasivaFromJson(jsonString);

import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

List<EntrenamientoActualizacionMasiva> entrenamientoActualizacionMasivaFromJson(String str) => List<EntrenamientoActualizacionMasiva>.from(json.decode(str).map((x) => EntrenamientoActualizacionMasiva.fromJson(x)));

String entrenamientoActualizacionMasivaToJson(List<EntrenamientoActualizacionMasiva> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EntrenamientoActualizacionMasiva {
  int? key;
  int? inEntrenamiento;
  String? codigoMcp;
  String? numeroDocumento;
  String? nombreCompleto;
  OptionValue? guardia;
  OptionValue? equipo;
  OptionValue? modulo;
  int? inNotaPractica;
  int? inNotaTeorica;
  DateTime? fechaExamen;
  int? inHorasAcumuladas;
  DateTime? fechaInicio;
  DateTime? fechaTermino;

  EntrenamientoActualizacionMasiva({
    this.key,
    this.inEntrenamiento,
    this.codigoMcp,
    this.numeroDocumento,
    this.nombreCompleto,
    this.guardia,
    this.equipo,
    this.modulo,
    this.inNotaPractica,
    this.inNotaTeorica,
    this.fechaExamen,
    this.inHorasAcumuladas,
    this.fechaInicio,
    this.fechaTermino,
  });

  factory EntrenamientoActualizacionMasiva.fromJson(Map<String, dynamic> json) => EntrenamientoActualizacionMasiva(
    key: json["Key"],
    inEntrenamiento: json["InEntrenamiento"],
    codigoMcp: json["CodigoMcp"],
    numeroDocumento: json["NumeroDocumento"],
    nombreCompleto: json["NombreCompleto"],
    guardia: json["Guardia"] == null ? null : OptionValue.fromJson(json["Guardia"]),
    equipo: json["Equipo"] == null ? null : OptionValue.fromJson(json["Equipo"]),
    modulo: json["Modulo"] == null ? null : OptionValue.fromJson(json["Modulo"]),
    inNotaPractica: json["InNotaPractica"],
    inNotaTeorica: json["InNotaTeorica"],
    fechaExamen: _fromDotNetDate(json["FechaExamen"]),
    inHorasAcumuladas: json["InHorasAcumuladas"],
    fechaInicio: _fromDotNetDate(json["FechaInicio"]),
    fechaTermino: _fromDotNetDate(json["FechaTermino"]),
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "InEntrenamiento": inEntrenamiento,
    "CodigoMcp": codigoMcp,
    "NumeroDocumento": numeroDocumento,
    "NombreCompleto": nombreCompleto,
    "Guardia": guardia?.toJson(),
    "Equipo": equipo?.toJson(),
    "Modulo": modulo?.toJson(),
    "InNotaPractica": inNotaPractica,
    "InNotaTeorica": inNotaTeorica,
    "FechaExamen": _toDotNetDate(fechaExamen!),
    "InHorasAcumuladas": inHorasAcumuladas,
    "FechaInicio": _toDotNetDate(fechaInicio!),
    "FechaTermino": _toDotNetDate(fechaTermino!),
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

