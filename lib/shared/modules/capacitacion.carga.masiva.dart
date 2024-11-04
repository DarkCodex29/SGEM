import 'dart:convert';

List<CapacitacionCargaMasiva> capacitacionCargaMasivaFromJson(String str) => List<CapacitacionCargaMasiva>.from(json.decode(str).map((x) => CapacitacionCargaMasiva.fromJson(x)));

String capacitacionCargaMasivaToJson(List<CapacitacionCargaMasiva> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CapacitacionCargaMasiva {
  String? codigo;
  String? dni;
  String? nombres;
  String? guardia;
  String? entrenador;
  String? nombreCapacitacion;
  String? categoria;
  String? empresa;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  int? horas;
  int? notaTeorica;
  int? notaPractica;

  CapacitacionCargaMasiva({
    this.codigo,
    this.dni,
    this.nombres,
    this.guardia,
    this.entrenador,
    this.nombreCapacitacion,
    this.categoria,
    this.empresa,
    this.fechaInicio,
    this.fechaTermino,
    this.horas,
    this.notaTeorica,
    this.notaPractica,
  });

  factory CapacitacionCargaMasiva.fromJson(Map<String, dynamic> json) => CapacitacionCargaMasiva(
    codigo: json["Codigo"],
    dni: json["Dni"],
    nombres: json["Nombres"],
    guardia: json["Guardia"],
    entrenador: json["Entrenador"],
    nombreCapacitacion: json["NombreCapacitacion"],
    categoria: json["Categoria"],
    empresa: json["Empresa"],
    fechaInicio: json["FechaInicio"] == null ? null : DateTime.parse(json["FechaInicio"]),
    fechaTermino: json["FechaTermino"] == null ? null : DateTime.parse(json["FechaTermino"]),
    horas: json["Horas"],
    notaTeorica: json["NotaTeorica"],
    notaPractica: json["NotaPractica"],
  );

  Map<String, dynamic> toJson() => {
    "Codigo": codigo,
    "Dni": dni,
    "Nombres": nombres,
    "Guardia": guardia,
    "Entrenador": entrenador,
    "NombreCapacitacion": nombreCapacitacion,
    "Categoria": categoria,
    "Empresa": empresa,
    "FechaInicio": fechaInicio?.toIso8601String(),
    "FechaTermino": fechaTermino?.toIso8601String(),
    "Horas": horas,
    "NotaTeorica": notaTeorica,
    "NotaPractica": notaPractica,
  };
}
