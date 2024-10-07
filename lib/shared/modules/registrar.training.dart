class RegisterTraining {
  
  int key;
  int inTipoActividad;
  int inCapacitacion;
  int inModulo;
  int inTipoPersona;
  int inPersona;
  int inActividadEntrenamiento;
  int inCategoria;
  int inEquipo;
  int inEntrenador;
  int inEmpresaCapacitadora;
  int inCondicion;
  DateTime fechaInicio;
  DateTime fechaTermino;
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

  RegisterTraining({
    this.key = 0,
    required this.inTipoActividad,
    this.inCapacitacion = 0,
    this.inModulo = 0,
    this.inTipoPersona = 0,
    required this.inPersona,
    this.inActividadEntrenamiento = 0,
    this.inCategoria = 0,
    required this.inEquipo,
    this.inEntrenador = 0,
    this.inEmpresaCapacitadora = 0,
    required this.inCondicion,
    required this.fechaInicio,
    required this.fechaTermino,
    this.fechaExamen,
    this.fechaRealMonitoreo,
    this.fechaProximoMonitoreo,
    this.inNotaTeorica = 0,
    this.inNotaPractica = 0,
    this.inTotalHoras = 0,
    this.inHorasAcumuladas = 0,
    this.inHorasMinestar = 0,
    this.inEstado = 0,
    this.comentarios = "",
    this.eliminado = "",
    this.motivoEliminado = "",
  });

  factory RegisterTraining.fromJson(Map<String, dynamic> json) {
    return RegisterTraining(
      key: json['Key'],
      inTipoActividad: json['InTipoActividad'],
      inCapacitacion: json['InCapacitacion'],
      inModulo: json['InModulo'],
      inTipoPersona: json['InTipoPersona'],
      inPersona: json['InPersona'],
      inActividadEntrenamiento: json['InActividadEntrenamiento'],
      inCategoria: json['InCategoria'],
      inEquipo: json['InEquipo'],
      inEntrenador: json['InEntrenador'],
      inEmpresaCapacitadora: json['InEmpresaCapacitadora'],
      inCondicion: json['InCondicion'],
      fechaInicio: DateTime.parse(json['FechaInicio']),
      fechaTermino: DateTime.parse(json['FechaTermino']),
      fechaExamen: DateTime.parse(json['FechaExamen']),
      fechaRealMonitoreo: DateTime.parse(json['FechaRealMonitoreo']),
      fechaProximoMonitoreo: DateTime.parse(json['FechaProximoMonitoreo']),
      inNotaTeorica: json['InNotaTeorica'],
      inNotaPractica: json['InNotaPractica'],
      inTotalHoras: json['InTotalHoras'],
      inHorasAcumuladas: json['InHorasAcumuladas'],
      inHorasMinestar: json['InHorasMinestar'],
      inEstado: json['InEstado'],
      comentarios: json['Comentarios'],
      eliminado: json['Eliminado'],
      motivoEliminado: json['MotivoEliminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'InTipoActividad': inTipoActividad,
      'InCapacitacion': inCapacitacion,
      'InModulo': inModulo,
      'InTipoPersona': inTipoPersona,
      'InPersona': inPersona,
      'InActividadEntrenamiento': inActividadEntrenamiento,
      'InCategoria': inCategoria,
      'InEquipo': inEquipo,
      'InEntrenador': inEntrenador,
      'InEmpresaCapacitadora': inEmpresaCapacitadora,
      'InCondicion': inCondicion,
      'FechaInicio': fechaInicio.toIso8601String(),
      'FechaTermino': fechaTermino.toIso8601String(),
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
