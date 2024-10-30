import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

List<CapacitacionConsulta> capacitacionConsultaFromJson(String str) =>
    List<CapacitacionConsulta>.from(
        json.decode(str).map((x) => CapacitacionConsulta.fromJson(x)));

String capacitacionConsultaToJson(List<CapacitacionConsulta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CapacitacionConsulta {
  int? key;
  String? codigoMcp;
  String? numeroDocumento;
  String? nombreCompleto;
  OptionValue guardia;
  OptionValue entrenador;
  OptionValue categoria;
  OptionValue empresaCapacitadora;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  int? inTotalHoras;
  int? inNotaTeorica;
  int? inNotaPractica;

  CapacitacionConsulta({
    this.key,
    this.codigoMcp,
    this.numeroDocumento,
    this.nombreCompleto,
    required this.guardia,
    required this.entrenador,
    required this.categoria,
    required this.empresaCapacitadora,
    this.fechaInicio,
    this.fechaTermino,
    this.inTotalHoras,
    this.inNotaTeorica,
    this.inNotaPractica,
  });

  factory CapacitacionConsulta.fromJson(Map<String, dynamic> json) =>
      CapacitacionConsulta(
        key: json["Key"],
        codigoMcp: json["CodigoMcp"],
        numeroDocumento: json["NumeroDocumento"],
        nombreCompleto: json["NombreCompleto"],
        guardia: OptionValue.fromJson(json["Guardia"]),
        entrenador: OptionValue.fromJson(json["Entrenador"]),
        categoria: OptionValue.fromJson(json["Categoria"]),
        empresaCapacitadora: OptionValue.fromJson(json["EmpresaCapacitadora"]),
        fechaInicio: _fromDotNetDate(json["FechaInicio"]),
        fechaTermino: _fromDotNetDate(json["FechaTermino"]),
        inTotalHoras: json["InTotalHoras"],
        inNotaTeorica: json["InNotaTeorica"],
        inNotaPractica: json["InNotaPractica"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "CodigoMcp": codigoMcp,
        "NumeroDocumento": numeroDocumento,
        "NombreCompleto": nombreCompleto,
        "Guardia": guardia.toJson(),
        "Entrenador": entrenador.toJson(),
        "Categoria": categoria.toJson(),
        "EmpresaCapacitadora": empresaCapacitadora.toJson(),
        "FechaInicio": _toDotNetDate(fechaInicio!),
        "FechaTermino": _toDotNetDate(fechaTermino!),
        "InTotalHoras": inTotalHoras,
        "InNotaTeorica": inNotaTeorica,
        "InNotaPractica": inNotaPractica,
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
