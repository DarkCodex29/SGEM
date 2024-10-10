class Entrenamiento {
  final int key;
  final int inTipoActividad;
  final int inCapacitacion;
  final int inModulo;
  final int inTipoPersona;
  final int inPersona;
  final int inActividadEntrenamiento;
  final int inCategoria;
  final int inEquipo;
  final int inEntrenador;
  final int inEmpresaCapacitadora;
  final int inCondicion;
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
    required this.inTipoPersona,
    required this.inPersona,
    required this.inActividadEntrenamiento,
    required this.inCategoria,
    required this.inEquipo,
    required this.inEntrenador,
    required this.inEmpresaCapacitadora,
    required this.inCondicion,
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
      inTipoPersona: json['InTipoPersona'],
      inPersona: json['InPersona'],
      inActividadEntrenamiento: json['InActividadEntrenamiento'],
      inCategoria: json['InCategoria'],
      inEquipo: json['InEquipo'],
      inEntrenador: json['InEntrenador'],
      inEmpresaCapacitadora: json['InEmpresaCapacitadora'],
      inCondicion: json['InCondicion'],
      fechaInicio: _fromJsonDate(json['FechaInicio']),
      fechaTermino: _fromJsonDate(json['FechaTermino']),
      fechaExamen: _fromJsonDate(json['FechaExamen']),
      fechaRealMonitoreo: _fromJsonDate(json['FechaRealMonitoreo']),
      fechaProximoMonitoreo: _fromJsonDate(json['FechaProximoMonitoreo']),
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
      'InTipoPersona': inTipoPersona,
      'InPersona': inPersona,
      'InActividadEntrenamiento': inActividadEntrenamiento,
      'InCategoria': inCategoria,
      'InEquipo': inEquipo,
      'InEntrenador': inEntrenador,
      'InEmpresaCapacitadora': inEmpresaCapacitadora,
      'InCondicion': inCondicion,
      'FechaInicio': _toJsonDate(fechaInicio),
      'FechaTermino': _toJsonDate(fechaTermino),
      'FechaExamen': _toJsonDate(fechaExamen),
      'FechaRealMonitoreo': _toJsonDate(fechaRealMonitoreo),
      'FechaProximoMonitoreo': _toJsonDate(fechaProximoMonitoreo),
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

  static DateTime? _fromJsonDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    final match = RegExp(r'\/Date\((\d+)\)\/').firstMatch(dateString);
    if (match != null) {
      final milliseconds = int.parse(match.group(1)!);
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
    return null;
  }

  static String? _toJsonDate(DateTime? date) {
    if (date == null) return null;
    return '/Date(${date.millisecondsSinceEpoch})/';
  }
}
