// To parse this JSON data, do
//
//     final monitoing = monitoingFromJson(jsonString);

import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

Monitoing monitoingFromJson(String str) => Monitoing.fromJson(json.decode(str));

String monitoingToJson(Monitoing data) => json.encode(data.toJson());

class Monitoing {
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
  dynamic fechaRealMonitoreo;

  Monitoing({
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

  factory Monitoing.fromJson(Map<String, dynamic> json) => Monitoing(
        key: json["Key"],
        codigoMcp: json["CodigoMcp"],
        primerNombre: json["PrimerNombre"],
        segundoNombre: json["SegundoNombre"],
        apellidoPaterno: json["ApellidoPaterno"],
        apellidoMaterno: json["ApellidoMaterno"],
        guardia: json["Guardia"] == null
            ? null
            : OptionValue.fromJson(json["Guardia"]),
        equipo:
            json["Equipo"] == null ? null : OptionValue.fromJson(json["Equipo"]),
        entrenador: json["Entrenador"] == null
            ? null
            : OptionValue.fromJson(json["Entrenador"]),
        condicion: json["Condicion"] == null
            ? null
            : OptionValue.fromJson(json["Condicion"]),
        fechaRealMonitoreo: json["FechaRealMonitoreo"],
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
