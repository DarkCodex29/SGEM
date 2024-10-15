import 'dart:convert';

EntrenamientoModulo entrenamientoModuloFromJson(String str) =>
    EntrenamientoModulo.fromJson(json.decode(str));

String entrenamientoModuloToJson(EntrenamientoModulo data) =>
    json.encode(data.toJson());

class EntrenamientoModulo {
  int key;
  int inTipoActividad;
  int inCapacitacion;
  int inModulo;
  Entidad modulo;
  int inTipoPersona;
  int inPersona;
  int inActividadEntrenamiento;
  int inCategoria;
  int inEquipo;
  Entidad equipo;
  int inEntrenador;
  Entidad entrenador;
  int inEmpresaCapacitadora;
  int inCondicion;
  Entidad condicion;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  DateTime? fechaExamen;
  DateTime? fechaRealMonitoreo;
  DateTime? fechaProximoMonitoreo;
  int inNotaTeorica;
  int inNotaPractica;
  int inTotalHoras;
  int inHorasAcumuladas;
  int inHorasMinestar;
  int inEstado;
  String comentarios;
  String eliminado;
  String motivoEliminado;

  EntrenamientoModulo({
    required this.key,
    required this.inTipoActividad,
    required this.inCapacitacion,
    required this.inModulo,
    required this.modulo,
    required this.inTipoPersona,
    required this.inPersona,
    required this.inActividadEntrenamiento,
    required this.inCategoria,
    required this.inEquipo,
    required this.equipo,
    required this.inEntrenador,
    required this.entrenador,
    required this.inEmpresaCapacitadora,
    required this.inCondicion,
    required this.condicion,
    this.fechaInicio,
    this.fechaTermino,
    this.fechaExamen,
    this.fechaRealMonitoreo,
    this.fechaProximoMonitoreo,
    required this.inNotaTeorica,
    required this.inNotaPractica,
    required this.inTotalHoras,
    required this.inHorasAcumuladas,
    required this.inHorasMinestar,
    required this.inEstado,
    required this.comentarios,
    required this.eliminado,
    required this.motivoEliminado,
  });

  factory EntrenamientoModulo.fromJson(Map<String, dynamic> json) =>
      EntrenamientoModulo(
        key: json["Key"] ?? 0,
        inTipoActividad: json["InTipoActividad"] ?? 0,
        inCapacitacion: json["InCapacitacion"] ?? 0,
        inModulo: json["InModulo"] ?? 0,
        modulo: Entidad.fromJson(json["Modulo"] ?? {}),
        inTipoPersona: json["InTipoPersona"] ?? 0,
        inPersona: json["InPersona"] ?? 0,
        inActividadEntrenamiento: json["InActividadEntrenamiento"] ?? 0,
        inCategoria: json["InCategoria"] ?? 0,
        inEquipo: json["InEquipo"] ?? 0,
        equipo: Entidad.fromJson(json["Equipo"] ?? {}),
        inEntrenador: json["InEntrenador"] ?? 0,
        entrenador: Entidad.fromJson(json["Entrenador"] ?? {}),
        inEmpresaCapacitadora: json["InEmpresaCapacitadora"] ?? 0,
        inCondicion: json["InCondicion"] ?? 0,
        condicion: Entidad.fromJson(json["Condicion"] ?? {}),
        fechaInicio: json["FechaInicio"] != null
            ? _fromDotNetDate(json["FechaInicio"])
            : null,
        fechaTermino: json["FechaTermino"] != null
            ? _fromDotNetDate(json["FechaTermino"])
            : null,
        fechaExamen: json["FechaExamen"] != null
            ? _fromDotNetDate(json["FechaExamen"])
            : null,
        fechaRealMonitoreo: json["FechaRealMonitoreo"] != null
            ? _fromDotNetDate(json["FechaRealMonitoreo"])
            : null,
        fechaProximoMonitoreo: json["FechaProximoMonitoreo"] != null
            ? _fromDotNetDate(json["FechaProximoMonitoreo"])
            : null,
        inNotaTeorica: json["InNotaTeorica"] ?? 0,
        inNotaPractica: json["InNotaPractica"] ?? 0,
        inTotalHoras: json["InTotalHoras"] ?? 0,
        inHorasAcumuladas: json["InHorasAcumuladas"] ?? 0,
        inHorasMinestar: json["InHorasMinestar"] ?? 0,
        inEstado: json["InEstado"] ?? 0,
        comentarios: json["Comentarios"] ?? '',
        eliminado: json["Eliminado"] ?? '',
        motivoEliminado: json["MotivoEliminado"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "InTipoActividad": inTipoActividad,
        "InCapacitacion": inCapacitacion,
        "InModulo": inModulo,
        "Modulo": modulo.toJson(),
        "InTipoPersona": inTipoPersona,
        "InPersona": inPersona,
        "InActividadEntrenamiento": inActividadEntrenamiento,
        "InCategoria": inCategoria,
        "InEquipo": inEquipo,
        "Equipo": equipo.toJson(),
        "InEntrenador": inEntrenador,
        "Entrenador": entrenador.toJson(),
        "InEmpresaCapacitadora": inEmpresaCapacitadora,
        "InCondicion": inCondicion,
        "Condicion": condicion.toJson(),
        "FechaInicio": _toDotNetDate(fechaInicio),
        "FechaTermino": _toDotNetDate(fechaTermino),
        "FechaExamen": _toDotNetDate(fechaExamen),
        "FechaRealMonitoreo": _toDotNetDate(fechaRealMonitoreo),
        "FechaProximoMonitoreo": _toDotNetDate(fechaProximoMonitoreo),
        "InNotaTeorica": inNotaTeorica,
        "InNotaPractica": inNotaPractica,
        "InTotalHoras": inTotalHoras,
        "InHorasAcumuladas": inHorasAcumuladas,
        "InHorasMinestar": inHorasMinestar,
        "InEstado": inEstado,
        "Comentarios": comentarios,
        "Eliminado": eliminado,
        "MotivoEliminado": motivoEliminado,
      };

  static DateTime _fromDotNetDate(String dotNetDate) {
    final milliseconds = int.parse(dotNetDate.replaceAll(RegExp(r'[^\d]'), ''));
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  static String _toDotNetDate(DateTime? date) {
    if (date == null) return '';
    return '/Date(${date.millisecondsSinceEpoch})/';
  }
}

class Entidad {
  int key;
  String nombre;

  Entidad({
    required this.key,
    required this.nombre,
  });

  factory Entidad.fromJson(Map<String, dynamic> json) => Entidad(
        key: json["Key"] ?? 0,
        nombre: json["Nombre"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "Nombre": nombre,
      };
}
