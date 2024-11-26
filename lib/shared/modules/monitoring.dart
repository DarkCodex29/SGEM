// To parse this JSON data, do
//
//     final monitoing = monitoingFromJson(jsonString);

import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/utils/functions/parse.date.time.dart';

Monitoring monitoingFromJson(String str) =>
    Monitoring.fromJson(json.decode(str));

String monitoingToJson(Monitoring data) => json.encode(data.toJson());

class Monitoring {
  int? key;
  String? codigoMcp;
  String? primerNombre;
  String? segundoNombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  OptionValue? guardia;
  OptionValue? equipo;
  OptionValue? entrenador;
  OptionValue? condicion;
  DateTime? fechaRealMonitoreo;

  Monitoring({
    this.key,
    this.codigoMcp,
    this.primerNombre,
    this.segundoNombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.guardia,
    this.equipo,
    this.entrenador,
    this.condicion,
    this.fechaRealMonitoreo,
  });

  factory Monitoring.fromJson(Map<String, dynamic> json) => Monitoring(
        key: json["Key"],
        codigoMcp: json["CodigoMcp"],
        primerNombre: json["PrimerNombre"],
        segundoNombre: json["SegundoNombre"],
        apellidoPaterno: json["ApellidoPaterno"],
        apellidoMaterno: json["ApellidoMaterno"],
        guardia: json["Guardia"] == null
            ? null
            : OptionValue.fromJson(json["Guardia"]),
        equipo: json["Equipo"] == null
            ? null
            : OptionValue.fromJson(json["Equipo"]),
        entrenador: json["Entrenador"] == null
            ? null
            : OptionValue.fromJson(json["Entrenador"]),
        condicion: json["Condicion"] == null
            ? null
            : OptionValue.fromJson(json["Condicion"]),
        fechaRealMonitoreo:json["FechaRealMonitoreo"] == null
            ? null: FnDateTime.fromDotNetDate(json["FechaRealMonitoreo"]),
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "CodigoMcp": codigoMcp,
        "PrimerNombre": primerNombre,
        "SegundoNombre": segundoNombre,
        "ApellidoPaterno": apellidoPaterno,
        "ApellidoMaterno": apellidoMaterno,
        "Guardia": guardia?.toJson(),
        "Equipo": equipo?.toJson(),
        "Entrenador": entrenador?.toJson(),
        "Condicion": condicion?.toJson(),
        "FechaRealMonitoreo": fechaRealMonitoreo,
      };
}
