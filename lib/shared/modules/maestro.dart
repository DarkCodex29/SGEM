class MaestroBasico {
  int key;
  String? nombre;

  MaestroBasico({
    required this.key,
    required this.nombre,
  });

  factory MaestroBasico.fromJson(Map<String, dynamic> json) {
    return MaestroBasico(
      key: json['Key'] ?? 0,
      nombre: json['Nombre'] ?? 'Desconocido',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}

class MaestroCompleto {
  int key;
  String nombre;
  String? descripcion;
  String? usuarioRegistro;
  DateTime fechaRegistro;
  String? usuarioModifica;
  DateTime? fechaModifica;
  String activo;

  MaestroCompleto({
    required this.key,
    required this.nombre,
    this.descripcion,
    this.usuarioRegistro,
    required this.fechaRegistro,
    this.usuarioModifica,
    this.fechaModifica,
    required this.activo,
  });

  factory MaestroCompleto.fromJson(Map<String, dynamic> json) {
    return MaestroCompleto(
      key: json['Key'] ?? 0,
      nombre: json['Nombre'] ?? 'Desconocido',
      descripcion: json['Descripcion'] ?? 'Sin descripción',
      usuarioRegistro: json['UsuarioRegistro'] ?? 'Desconocido',
      fechaRegistro: parseDate(json['FechaRegistro']),
      usuarioModifica: json['UsuarioModifica']?.isNotEmpty == true
          ? json['UsuarioModifica']
          : 'Desconocido',
      fechaModifica: json['FechaModifica'] != null
          ? parseDate(json['FechaModifica'])
          : null,
      activo: json['Activo'] ?? 'N',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
      'Descripcion': descripcion,
      'UsuarioRegistro': usuarioRegistro,
      'FechaRegistro': toJsonDate(fechaRegistro),
      'UsuarioModifica': usuarioModifica,
      'FechaModifica':
          fechaModifica != null ? toJsonDate(fechaModifica!) : null,
      'Activo': activo,
    };
  }

  static DateTime parseDate(String dateString) {
    if (dateString.contains('/Date')) {
      final timestamp = dateString.replaceAll(RegExp(r'[^0-9]'), '');
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    } else {
      return DateTime.parse(dateString);
    }
  }

  static DateTime? parseDateNullable(String? dateString) {
    if (dateString == null) {
      return null;
    } else {
      return parseDate(dateString);
    }
  }

  static String toJsonDate(DateTime date) {
    return '/Date(${date.millisecondsSinceEpoch})/';
  }

  static String? toJsonDateNullable(DateTime? date) {
    if (date == null) {
      return null;
    } else {
      return toJsonDate(date);
    }
  }
}
