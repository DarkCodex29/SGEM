import 'dart:convert';

EntrenamientoModulo entrenamientoModuloFromJson(String str) => EntrenamientoModulo.fromJson(json.decode(str));

String entrenamientoModuloToJson(EntrenamientoModulo data) => json.encode(data.toJson());

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
  DateTime fechaInicio;
  DateTime fechaTermino;
  DateTime fechaExamen;
  DateTime fechaRealMonitoreo;
  DateTime fechaProximoMonitoreo;
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
    required this.fechaInicio,
    required this.fechaTermino,
    required this.fechaExamen,
    required this.fechaRealMonitoreo,
    required this.fechaProximoMonitoreo,
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

  factory EntrenamientoModulo.fromJson(Map<String, dynamic> json) => EntrenamientoModulo(
    key: json["Key"],
    inTipoActividad: json["InTipoActividad"],
    inCapacitacion: json["InCapacitacion"],
    inModulo: json["InModulo"],
    modulo: Entidad.fromJson(json["Modulo"]),
    inTipoPersona: json["InTipoPersona"],
    inPersona: json["InPersona"],
    inActividadEntrenamiento: json["InActividadEntrenamiento"],
    inCategoria: json["InCategoria"],
    inEquipo: json["InEquipo"],
    equipo: Entidad.fromJson(json["Equipo"]),
    inEntrenador: json["InEntrenador"],
    entrenador: Entidad.fromJson(json["Entrenador"]),
    inEmpresaCapacitadora: json["InEmpresaCapacitadora"],
    inCondicion: json["InCondicion"],
    condicion: Entidad.fromJson(json["Condicion"]),
    fechaInicio: _fromDotNetDate(json["FechaInicio"]),
    fechaTermino: _fromDotNetDate(json["FechaTermino"]),
    fechaExamen: _fromDotNetDate(json["FechaExamen"]),
    fechaRealMonitoreo: _fromDotNetDate(json["FechaRealMonitoreo"]),
    fechaProximoMonitoreo: _fromDotNetDate(json["FechaProximoMonitoreo"]),
    inNotaTeorica: json["InNotaTeorica"],
    inNotaPractica: json["InNotaPractica"],
    inTotalHoras: json["InTotalHoras"],
    inHorasAcumuladas: json["InHorasAcumuladas"],
    inHorasMinestar: json["InHorasMinestar"],
    inEstado: json["InEstado"],
    comentarios: json["Comentarios"],
    eliminado: json["Eliminado"],
    motivoEliminado: json["MotivoEliminado"],
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

class Entidad {
  int key;
  String nombre;

  Entidad({
    required this.key,
    required this.nombre,
  });

  factory Entidad.fromJson(Map<String, dynamic> json) => Entidad(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
