import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';

class Personal implements DropdownElement {
  int? key;
  String? tipoPersona;
  int? inPersonalOrigen;
  DateTime? fechaIngresoMina;
  String? licenciaConducir;
  String? operacionMina;
  String? zonaPlataforma;
  String? restricciones;
  String? usuarioRegistro;
  String? usuarioModifica;
  String? codigoMcp;
  String? nombreCompleto;
  String? cargo;
  String? numeroDocumento;
  OptionValue? guardia;
  OptionValue? estado;
  String? eliminado;
  String? motivoElimina;
  String? usuarioElimina;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? primerNombre;
  String? segundoNombre;
  DateTime? fechaIngreso;
  String? licenciaCategoria;
  DateTime? licenciaVencimiento;
  String? gerencia;
  String? area;

  @override
  String get value => nombreCompleto!;
  @override
  int get id => key!;

  Personal({
    this.key,
    this.tipoPersona,
    this.inPersonalOrigen,
    this.fechaIngresoMina,
    this.licenciaConducir,
    this.operacionMina,
    this.zonaPlataforma,
    this.restricciones,
    this.usuarioRegistro,
    this.usuarioModifica,
    this.codigoMcp,
    this.nombreCompleto,
    this.cargo,
    this.numeroDocumento,
    this.guardia,
    this.estado,
    this.eliminado,
    this.motivoElimina,
    this.usuarioElimina,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.primerNombre,
    this.segundoNombre,
    this.fechaIngreso,
    this.licenciaCategoria,
    this.licenciaVencimiento,
    this.gerencia,
    this.area,
  });

  static DateTime? parseDate(dynamic rawDate) {
    if (rawDate == null) {
      return null;
    }
    if (rawDate is String) {
      final regExp = RegExp(r'\/Date\((\d+)\)\/');
      final match = regExp.firstMatch(rawDate);
      if (match != null) {
        final timestamp = int.parse(match.group(1)!);
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      try {
        return DateTime.parse(rawDate);
      } catch (e) {
        return null;
      }
    } else if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate);
    }
    return null;
  }

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      key: json['Key'] ?? 0,
      tipoPersona: json['TipoPersona'] ?? "",
      inPersonalOrigen: json['InPersonalOrigen'] ?? 0,
      fechaIngresoMina: parseDate(json['FechaIngresoMina']),
      licenciaConducir: json['LicenciaConducir'] ?? "",
      operacionMina: json['OperacionMina'] ?? "S",
      zonaPlataforma: json['ZonaPlataforma'] ?? "S",
      restricciones: json['Restricciones'] ?? "",
      usuarioRegistro: json['UsuarioRegistro'] ?? "",
      usuarioModifica: json['UsuarioModifica'] ?? "",
      codigoMcp: json['CodigoMcp'] ?? "",
      nombreCompleto: json['NombreCompleto'] ?? "",
      cargo: json['Cargo'] ?? "",
      numeroDocumento: json['NumeroDocumento'] ?? "",
      guardia: OptionValue.fromJson(json['Guardia'] ?? {}),
      estado: OptionValue.fromJson(json['Estado'] ?? {}),
      eliminado: json['Eliminado'] ?? "S",
      motivoElimina: json['MotivoElimina'] ?? "",
      usuarioElimina: json['UsuarioElimina'] ?? "",
      apellidoPaterno: json['ApellidoPaterno'] ?? "",
      apellidoMaterno: json['ApellidoMaterno'] ?? "",
      primerNombre: json['PrimerNombre'] ?? "",
      segundoNombre: json['SegundoNombre'] ?? "",
      fechaIngreso: parseDate(json['FechaIngreso']),
      licenciaCategoria: json['LicenciaCategoria'] ?? "",
      licenciaVencimiento: parseDate(json['LicenciaVencimiento']),
      gerencia: json['Gerencia'] ?? "",
      area: json['Area'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'TipoPersona': tipoPersona,
      'InPersonalOrigen': inPersonalOrigen,
      'FechaIngresoMina': fechaIngresoMina?.toIso8601String(),
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
      'Guardia': guardia!.toJson(),
      'Estado': estado!.toJson(),
      'Eliminado': eliminado,
      'MotivoElimina': motivoElimina,
      'UsuarioElimina': usuarioElimina,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      'PrimerNombre': primerNombre,
      'SegundoNombre': segundoNombre,
      'FechaIngreso': fechaIngreso?.toIso8601String(),
      'LicenciaCategoria': licenciaCategoria,
      'LicenciaVencimiento': licenciaVencimiento?.toIso8601String(),
      'Gerencia': gerencia,
      'Area': area,
    };
  }
}
/*
class Guardia {
  int? key;
  String? nombre;

  Guardia({
    this.key,
    this.nombre,
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
  int? key;
  String? nombre;

  Estado({
    this.key,
    this.nombre,
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
*/