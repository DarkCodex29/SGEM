class Personal {
  int key;
  String tipoPersona;
  int inPersonalOrigen;
  DateTime? fechaIngresoMina;
  String licenciaConducir;
  String operacionMina;
  String zonaPlataforma;
  String restricciones;
  String usuarioRegistro;
  String usuarioModifica;
  String codigoMcp;
  String nombreCompleto;
  String cargo;
  String numeroDocumento;
  Guardia guardia;
  Estado estado;
  String eliminado;
  String motivoElimina;
  String usuarioElimina;
  String apellidoPaterno;
  String apellidoMaterno;
  String primerNombre;
  String segundoNombre;
  DateTime? fechaIngreso;
  String licenciaCategoria;
  DateTime? licenciaVencimiento;
  String gerencia;
  String area;

  Personal({
    required this.key,
    required this.tipoPersona,
    required this.inPersonalOrigen,
    this.fechaIngresoMina,
    required this.licenciaConducir,
    required this.operacionMina,
    required this.zonaPlataforma,
    required this.restricciones,
    required this.usuarioRegistro,
    required this.usuarioModifica,
    required this.codigoMcp,
    required this.nombreCompleto,
    required this.cargo,
    required this.numeroDocumento,
    required this.guardia,
    required this.estado,
    required this.eliminado,
    required this.motivoElimina,
    required this.usuarioElimina,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.primerNombre,
    required this.segundoNombre,
    this.fechaIngreso,
    required this.licenciaCategoria,
    this.licenciaVencimiento,
    required this.gerencia,
    required this.area,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      key: json['Key'] ?? 0,
      tipoPersona: json['TipoPersona'] ?? "",
      inPersonalOrigen: json['InPersonalOrigen'] ?? 0,
      fechaIngresoMina: json['FechaIngresoMina'] != null
          ? DateTime.tryParse(json['FechaIngresoMina'])
          : null,
      licenciaConducir: json['LicenciaConducir'] ?? "",
      operacionMina: json['OperacionMina'] ?? "",
      zonaPlataforma: json['ZonaPlataforma'] ?? "",
      restricciones: json['Restricciones'] ?? "",
      usuarioRegistro: json['UsuarioRegistro'] ?? "",
      usuarioModifica: json['UsuarioModifica'] ?? "",
      codigoMcp: json['CodigoMcp'] ?? "",
      nombreCompleto: json['NombreCompleto'] ?? "",
      cargo: json['Cargo'] ?? "",
      numeroDocumento: json['NumeroDocumento'] ?? "",
      guardia: json['Guardia'] != null
          ? Guardia.fromJson(json['Guardia'])
          : Guardia(key: 0, nombre: ""),
      estado: json['Estado'] != null
          ? Estado.fromJson(json['Estado'])
          : Estado(key: 0, nombre: ""),
      eliminado: json['Eliminado'] ?? "",
      motivoElimina: json['MotivoElimina'] ?? "",
      usuarioElimina: json['UsuarioElimina'] ?? "",
      apellidoPaterno: json['ApellidoPaterno'] ?? "",
      apellidoMaterno: json['ApellidoMaterno'] ?? "",
      primerNombre: json['PrimerNombre'] ?? "",
      segundoNombre: json['SegundoNombre'] ?? "",
      fechaIngreso: json['FechaIngreso'] != null
          ? DateTime.tryParse(json['FechaIngreso'])
          : null,
      licenciaCategoria: json['LicenciaCategoria'] ?? "",
      licenciaVencimiento: json['LicenciaVencimiento'] != null
          ? DateTime.tryParse(json['LicenciaVencimiento'])
          : null,
      gerencia: json['Gerencia'] ?? "",
      area: json['Area'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'TipoPersona': tipoPersona,
      'InPersonalOrigen': inPersonalOrigen,
      'FechaIngresoMina': fechaIngresoMina?.toIso8601String() ?? "",
      'LicenciaConducir': licenciaConducir,
      'OperacionMina': operacionMina,
      'ZonaPlataforma': zonaPlataforma,
      'Restricciones': restricciones,
      'UsuarioRegistro': usuarioRegistro,
      'UsuarioModifica': usuarioModifica,
      'CodigoMcp': codigoMcp,
      'NombreCompleto': nombreCompleto,
      'Cargo': cargo,
      'NumeroDocumento': numeroDocumento,
      'Guardia': guardia.toJson(),
      'Estado': estado.toJson(),
      'Eliminado': eliminado,
      'MotivoElimina': motivoElimina,
      'UsuarioElimina': usuarioElimina,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      'PrimerNombre': primerNombre,
      'SegundoNombre': segundoNombre,
      'FechaIngreso': fechaIngreso?.toIso8601String() ?? "",
      'LicenciaCategoria': licenciaCategoria,
      'LicenciaVencimiento': licenciaVencimiento?.toIso8601String() ?? "",
      'Gerencia': gerencia,
      'Area': area,
    };
  }
}

class Guardia {
  int key;
  String nombre;

  Guardia({
    required this.key,
    required this.nombre,
  });

  factory Guardia.fromJson(Map<String, dynamic> json) {
    return Guardia(
      key: json['Key'] ?? 0,
      nombre: json['Nombre'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}

class Estado {
  int key;
  String nombre;

  Estado({
    required this.key,
    required this.nombre,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      key: json['Key'] ?? 0,
      nombre: json['Nombre'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Nombre': nombre,
    };
  }
}
