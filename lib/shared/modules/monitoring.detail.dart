import 'dart:convert';

import 'package:sgem/shared/modules/option.value.dart';

MonitoringDetail monitoringDetailFromJson(String str) => MonitoringDetail.fromJson(json.decode(str));

String monitoringDetailToJson(MonitoringDetail data) => json.encode(data.toJson());

class MonitoringDetail {
    int? key;
    int? inTipoActividad;
    int? inCapacitacion;
    int? inModulo;
    OptionValue? modulo;
    String? tipoPersona;
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
    dynamic fechaInicio;
    dynamic fechaTermino;
    dynamic fechaExamen;
    String? fechaRealMonitoreo;
    String? fechaProximoMonitoreo;
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

    MonitoringDetail({
        this.key,
        this.inTipoActividad,
        this.inCapacitacion,
        this.inModulo,
        this.modulo,
        this.tipoPersona,
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

    factory MonitoringDetail.fromJson(Map<String, dynamic> json) => MonitoringDetail(
        key: json["Key"],
        inTipoActividad: json["InTipoActividad"],
        inCapacitacion: json["InCapacitacion"],
        inModulo: json["InModulo"],
        modulo: json["Modulo"] == null ? null : OptionValue.fromJson(json["Modulo"]),
        tipoPersona: json["TipoPersona"],
        inPersona: json["InPersona"],
        inActividadEntrenamiento: json["InActividadEntrenamiento"],
        inCategoria: json["InCategoria"],
        inEquipo: json["InEquipo"],
        equipo: json["Equipo"] == null ? null : OptionValue.fromJson(json["Equipo"]),
        inEntrenador: json["InEntrenador"],
        entrenador: json["Entrenador"] == null ? null : OptionValue.fromJson(json["Entrenador"]),
        inEmpresaCapacitadora: json["InEmpresaCapacitadora"],
        inCondicion: json["InCondicion"],
        condicion: json["Condicion"] == null ? null : OptionValue.fromJson(json["Condicion"]),
        fechaInicio: json["FechaInicio"],
        fechaTermino: json["FechaTermino"],
        fechaExamen: json["FechaExamen"],
        fechaRealMonitoreo: json["FechaRealMonitoreo"],
        fechaProximoMonitoreo: json["FechaProximoMonitoreo"],
        inNotaTeorica: json["InNotaTeorica"],
        inNotaPractica: json["InNotaPractica"],
        inTotalHoras: json["InTotalHoras"],
        inHorasAcumuladas: json["InHorasAcumuladas"],
        inHorasMinestar: json["InHorasMinestar"],
        inEstado: json["InEstado"],
        estadoEntrenamiento: json["EstadoEntrenamiento"] == null ? null : OptionValue.fromJson(json["EstadoEntrenamiento"]),
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
        "TipoPersona": tipoPersona,
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
        "FechaInicio": fechaInicio,
        "FechaTermino": fechaTermino,
        "FechaExamen": fechaExamen,
        "FechaRealMonitoreo": fechaRealMonitoreo,
        "FechaProximoMonitoreo": fechaProximoMonitoreo,
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