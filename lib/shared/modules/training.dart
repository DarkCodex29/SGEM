class Entrenamiento {
  final int key;
  final int inTipoActividad;
  final int inCapacitacion;
  final int inModulo;
  final Modulo? modulo;
  final int inTipoPersona;
  final int inPersona;
  final int inActividadEntrenamiento;
  final int inCategoria;
  final int inEquipo;
  final Equipo? equipo;
  final int inEntrenador;
  final Entrenador? entrenador;
  final int inEmpresaCapacitadora;
  final int inCondicion;
  final Condicion? condicion;
  final DateTime? fechaInicio;
  final DateTime? fechaTermino;
  final DateTime? fechaExamen;
  final DateTime? fechaRealMonitoreo;
  final DateTime? fechaProximoMonitoreo;
  final int inNotaTeorica;
  final int inNotaPractica;
  final int inTotalHoras;
  final int inHorasAcumuladas;
  final int inHorasMinestar;
  final int inEstado;
  final String comentarios;
  final String eliminado;
  final String motivoEliminado;

  Entrenamiento({
    required this.key,
    required this.inTipoActividad,
    required this.inCapacitacion,
    required this.inModulo,
    this.modulo,
    required this.inTipoPersona,
    required this.inPersona,
    required this.inActividadEntrenamiento,
    required this.inCategoria,
    required this.inEquipo,
    this.equipo,
    required this.inEntrenador,
    this.entrenador,
    required this.inEmpresaCapacitadora,
    required this.inCondicion,
    this.condicion,
    required this.fechaInicio,
    required this.fechaTermino,
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

  factory Entrenamiento.fromJson(Map<String, dynamic> json) {
    return Entrenamiento(
      key: json['Key'],
      inTipoActividad: json['InTipoActividad'],
      inCapacitacion: json['InCapacitacion'],
      inModulo: json['InModulo'],
      modulo: json['Modulo'] != null ? Modulo.fromJson(json['Modulo']) : null,
      inTipoPersona: json['InTipoPersona'],
      inPersona: json['InPersona'],
      inActividadEntrenamiento: json['InActividadEntrenamiento'],
      inCategoria: json['InCategoria'],
      inEquipo: json['InEquipo'],
      equipo: json['Equipo'] != null ? Equipo.fromJson(json['Equipo']) : null,
      inEntrenador: json['InEntrenador'],
      entrenador: json['Entrenador'] != null
          ? Entrenador.fromJson(json['Entrenador'])
          : null,
      inEmpresaCapacitadora: json['InEmpresaCapacitadora'],
      inCondicion: json['InCondicion'],
      condicion: json['Condicion'] != null
          ? Condicion.fromJson(json['Condicion'])
          : null,
      fechaInicio: DateTime.tryParse(json['FechaInicio'] ?? ''),
      fechaTermino: DateTime.tryParse(json['FechaTermino'] ?? ''),
      fechaExamen: DateTime.tryParse(json['FechaExamen'] ?? ''),
      fechaRealMonitoreo: DateTime.tryParse(json['FechaRealMonitoreo'] ?? ''),
      fechaProximoMonitoreo:
          DateTime.tryParse(json['FechaProximoMonitoreo'] ?? ''),
      inNotaTeorica: json['InNotaTeorica'],
      inNotaPractica: json['InNotaPractica'],
      inTotalHoras: json['InTotalHoras'],
      inHorasAcumuladas: json['InHorasAcumuladas'],
      inHorasMinestar: json['InHorasMinestar'],
      inEstado: json['InEstado'],
      comentarios: json['Comentarios'] ?? '',
      eliminado: json['Eliminado'] ?? '',
      motivoEliminado: json['MotivoEliminado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'InTipoActividad': inTipoActividad,
      'InCapacitacion': inCapacitacion,
      'InModulo': inModulo,
      'Modulo': modulo?.toJson(),
      'InTipoPersona': inTipoPersona,
      'InPersona': inPersona,
      'InActividadEntrenamiento': inActividadEntrenamiento,
      'InCategoria': inCategoria,
      'InEquipo': inEquipo,
      'Equipo': equipo?.toJson(),
      'InEntrenador': inEntrenador,
      'Entrenador': entrenador?.toJson(),
      'InEmpresaCapacitadora': inEmpresaCapacitadora,
      'InCondicion': inCondicion,
      'Condicion': condicion?.toJson(),
      'FechaInicio': fechaInicio?.toIso8601String(),
      'FechaTermino': fechaTermino?.toIso8601String(),
      'FechaExamen': fechaExamen?.toIso8601String(),
      'FechaRealMonitoreo': fechaRealMonitoreo?.toIso8601String(),
      'FechaProximoMonitoreo': fechaProximoMonitoreo?.toIso8601String(),
      'InNotaTeorica': inNotaTeorica,
      'InNotaPractica': inNotaPractica,
      'InTotalHoras': inTotalHoras,
      'InHorasAcumuladas': inHorasAcumuladas,
      'InHorasMinestar': inHorasMinestar,
      'InEstado': inEstado,
      'Comentarios': comentarios,
      'Eliminado': eliminado,
      'MotivoEliminado': motivoEliminado,
    };
  }
}

class Modulo {
  final int key;
  final String nombre;

  Modulo({required this.key, required this.nombre});

  factory Modulo.fromJson(Map<String, dynamic> json) {
    return Modulo(
      key: json['Key'],
      nombre: json['Nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}

class Equipo {
  final int key;
  final String nombre;

  Equipo({required this.key, required this.nombre});

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      key: json['Key'],
      nombre: json['Nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}

class Entrenador {
  final int key;
  final String nombre;

  Entrenador({required this.key, required this.nombre});

  factory Entrenador.fromJson(Map<String, dynamic> json) {
    return Entrenador(
      key: json['Key'],
      nombre: json['Nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}

class Condicion {
  final int key;
  final String nombre;

  Condicion({required this.key, required this.nombre});

  factory Condicion.fromJson(Map<String, dynamic> json) {
    return Condicion(
      key: json['Key'],
      nombre: json['Nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}
