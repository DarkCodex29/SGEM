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
  String? licenciaCategoria=' ';
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

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      key: json['Key'] ?? 0,
      tipoPersona: json['TipoPersona'] ?? "",
      inPersonalOrigen: json['InPersonalOrigen'] ?? 0,
      fechaIngresoMina: json['FechaIngresoMina'] != null
          ? _fromDotNetDate(json['FechaIngresoMina'])
          : null,
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
      fechaIngreso: json['FechaIngreso'] != null
          ? _fromDotNetDate(json['FechaIngreso'])
          : null,
      licenciaCategoria: json['LicenciaCategoria'] ?? "",
      licenciaVencimiento: json['LicenciaVencimiento'] != null
          ? _fromDotNetDate(json['LicenciaVencimiento'])
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
      'FechaIngresoMina': _toDotNetDate(fechaIngresoMina),
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
      'FechaIngreso': _toDotNetDate(fechaIngreso),
      'LicenciaCategoria': licenciaCategoria,
      'LicenciaVencimiento': _toDotNetDate(licenciaVencimiento),
      'Gerencia': gerencia,
      'Area': area,
    };
  }

  static DateTime _fromDotNetDate(String dotNetDate) {
    final milliseconds = int.parse(dotNetDate.replaceAll(RegExp(r'[^\d]'), ''));
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  static String _toDotNetDate(DateTime? date) {
    if (date == null) return '';
    return "/Date(${date.millisecondsSinceEpoch})/";
  }
}
