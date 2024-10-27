import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

MonitoingSave monitoingSaveFromJson(String str) =>
    MonitoingSave.fromJson(json.decode(str));

String monitoingSaveToJson(MonitoingSave data) => json.encode(data.toJson());

class MonitoingSave {
  int? key;
  int? inTipoActividad;
  int? inCapacitacion;
  int? inModulo;
  OptionValue? modulo;
  int? inTipoPersona;
  int? inPersona;
  int? inActividadEntrenamiento;
  int? inCategoria;
  int? inEquipo;
  OptionValue? equipo;
  int? inEntrenador;
  OptionValue? entrenador;
  int? inEmpresaCapacitadora;
  int? inCondicion;
  OptionValue? condicion;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  DateTime? fechaExamen;
  DateTime? fechaRealMonitoreo;
  DateTime? fechaProximoMonitoreo;
  int? inNotaTeorica;
  int? inNotaPractica;
  int? inTotalHoras;
  int? inHorasAcumuladas;
  int? inHorasMinestar;
  int? inEstado;
  OptionValue? estadoEntrenamiento;
  String? comentarios;
  String? eliminado;
  String? motivoEliminado;
  String? observacionesEntrenamiento;

  MonitoingSave({
    this.key,
    this.inTipoActividad,
    this.inCapacitacion,
    this.inModulo,
    this.modulo,
    this.inTipoPersona,
    this.inPersona,
    this.inActividadEntrenamiento,
    this.inCategoria,
    this.inEquipo,
    this.equipo,
    this.inEntrenador,
    this.entrenador,
    this.inEmpresaCapacitadora,
    this.inCondicion,
    this.condicion,
    this.fechaInicio,
    this.fechaTermino,
    this.fechaExamen,
    this.fechaRealMonitoreo,
    this.fechaProximoMonitoreo,
    this.inNotaTeorica,
    this.inNotaPractica,
    this.inTotalHoras,
    this.inHorasAcumuladas,
    this.inHorasMinestar,
    this.inEstado,
    this.estadoEntrenamiento,
    this.comentarios,
    this.eliminado,
    this.motivoEliminado,
    this.observacionesEntrenamiento,
  });

  factory MonitoingSave.fromJson(Map<String, dynamic> json) => MonitoingSave(
        key: json["Key"],
        inTipoActividad: json["InTipoActividad"],
        inCapacitacion: json["InCapacitacion"],
        inModulo: json["InModulo"],
        modulo: json["Modulo"] == null
            ? null
            : OptionValue.fromJson(json["Modulo"]),
        inTipoPersona: json["InTipoPersona"],
        inPersona: json["InPersona"],
        inActividadEntrenamiento: json["InActividadEntrenamiento"],
        inCategoria: json["InCategoria"],
        inEquipo: json["InEquipo"],
        equipo: json["Equipo"] == null
            ? null
            : OptionValue.fromJson(json["Equipo"]),
        inEntrenador: json["InEntrenador"],
        entrenador: json["Entrenador"] == null
            ? null
            : OptionValue.fromJson(json["Entrenador"]),
        inEmpresaCapacitadora: json["InEmpresaCapacitadora"],
        inCondicion: json["InCondicion"],
        condicion: json["Condicion"] == null
            ? null
            : OptionValue.fromJson(json["Condicion"]),
        fechaInicio: json["FechaInicio"] == null
            ? null
            : DateTime.parse(json["FechaInicio"]),
        fechaTermino: json["FechaTermino"] == null
            ? null
            : DateTime.parse(json["FechaTermino"]),
        fechaExamen: json["FechaExamen"] == null
            ? null
            : DateTime.parse(json["FechaExamen"]),
        fechaRealMonitoreo: json["FechaRealMonitoreo"] == null
            ? null
            : DateTime.parse(json["FechaRealMonitoreo"]),
        fechaProximoMonitoreo: json["FechaProximoMonitoreo"] == null
            ? null
            : DateTime.parse(json["FechaProximoMonitoreo"]),
        inNotaTeorica: json["InNotaTeorica"],
        inNotaPractica: json["InNotaPractica"],
        inTotalHoras: json["InTotalHoras"],
        inHorasAcumuladas: json["InHorasAcumuladas"],
        inHorasMinestar: json["InHorasMinestar"],
        inEstado: json["InEstado"],
        estadoEntrenamiento: json["EstadoEntrenamiento"] == null
            ? null
            : OptionValue.fromJson(json["EstadoEntrenamiento"]),
        comentarios: json["Comentarios"],
        eliminado: json["Eliminado"],
        motivoEliminado: json["MotivoEliminado"],
        observacionesEntrenamiento: json["ObservacionesEntrenamiento"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "InTipoActividad": inTipoActividad,
        "InCapacitacion": inCapacitacion,
        "InModulo": inModulo,
        "Modulo": modulo?.toJson(),
        "InTipoPersona": inTipoPersona,
        "InPersona": inPersona,
        "InActividadEntrenamiento": inActividadEntrenamiento,
        "InCategoria": inCategoria,
        "InEquipo": inEquipo,
        "Equipo": equipo?.toJson(),
        "InEntrenador": inEntrenador,
        "Entrenador": entrenador?.toJson(),
        "InEmpresaCapacitadora": inEmpresaCapacitadora,
        "InCondicion": inCondicion,
        "Condicion": condicion?.toJson(),
        "FechaInicio": fechaInicio?.toIso8601String(),
        "FechaTermino": fechaTermino?.toIso8601String(),
        "FechaExamen": fechaExamen?.toIso8601String(),
        "FechaRealMonitoreo": fechaRealMonitoreo?.toIso8601String(),
        "FechaProximoMonitoreo": fechaProximoMonitoreo?.toIso8601String(),
        "InNotaTeorica": inNotaTeorica,
        "InNotaPractica": inNotaPractica,
        "InTotalHoras": inTotalHoras,
        "InHorasAcumuladas": inHorasAcumuladas,
        "InHorasMinestar": inHorasMinestar,
        "InEstado": inEstado,
        "EstadoEntrenamiento": estadoEntrenamiento?.toJson(),
        "Comentarios": comentarios,
        "Eliminado": eliminado,
        "MotivoEliminado": motivoEliminado,
        "ObservacionesEntrenamiento": observacionesEntrenamiento,
      };
}
