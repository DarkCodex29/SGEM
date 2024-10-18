import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

List<EntrenamientoConsulta> entrenamientoConsultaFromJson(String str) =>
    List<EntrenamientoConsulta>.from(
        json.decode(str).map((x) => EntrenamientoConsulta.fromJson(x)));

String entrenamientoConsultaToJson(List<EntrenamientoConsulta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EntrenamientoConsulta {
  int key;
  int inEntrenamiento;
  String codigoMcp;
  String nombreCompleto;
  OptionValue guardia;
  OptionValue estadoEntrenamiento;
  OptionValue modulo;
  OptionValue entrenador;
  int notaTeorica;
  int notaPractica;
  int horasAcumuladas;
  OptionValue condicion;
  OptionValue equipo;
  DateTime? fechaInicio;
  DateTime? fechaTermino;

  EntrenamientoConsulta({
    required this.key,
    required this.inEntrenamiento,
    required this.codigoMcp,
    required this.nombreCompleto,
    required this.guardia,
    required this.estadoEntrenamiento,
    required this.modulo,
    required this.entrenador,
    required this.notaTeorica,
    required this.notaPractica,
    required this.horasAcumuladas,
    required this.condicion,
    required this.equipo,
    required this.fechaInicio,
    required this.fechaTermino,
  });

  factory EntrenamientoConsulta.fromJson(Map<String, dynamic> json) =>
      EntrenamientoConsulta(
        key: json["Key"],
        inEntrenamiento: json["InEntrenamiento"],
        codigoMcp: json["CodigoMcp"],
        nombreCompleto: json["NombreCompleto"],
        guardia: OptionValue.fromJson(json["Guardia"]),
        estadoEntrenamiento:
        OptionValue.fromJson(json["EstadoEntrenamiento"]),
        modulo: OptionValue.fromJson(json["Modulo"]),
        entrenador: OptionValue.fromJson(json["Entrenador"]),
        notaTeorica: json["NotaTeorica"],
        notaPractica: json["NotaPractica"],
        horasAcumuladas: json["HorasAcumuladas"],
        condicion: OptionValue.fromJson(json["Condicion"]),
        equipo: OptionValue.fromJson(json["Equipo"]),
        fechaInicio: _fromDotNetDate(json["FechaInicio"]),
        fechaTermino: _fromDotNetDate(json["FechaTermino"]),
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "InEntrenamiento": inEntrenamiento,
        "CodigoMcp": codigoMcp,
        "NombreCompleto": nombreCompleto,
        "Guardia": guardia.toJson(),
        "EstadoEntrenamiento": estadoEntrenamiento.toJson(),
        "Modulo": modulo.toJson(),
        "Entrenador": entrenador.toJson(),
        "NotaTeorica": notaTeorica,
        "NotaPractica": notaPractica,
        "HorasAcumuladas": horasAcumuladas,
        "Condicion": condicion.toJson(),
        "Equipo": equipo.toJson(),
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
