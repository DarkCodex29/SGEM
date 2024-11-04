import 'dart:convert';

List<CapacitacionCargaMasivaValidado> capacitacionCargaMasivaValidadoFromJson(
        String str) =>
    List<CapacitacionCargaMasivaValidado>.from(json
        .decode(str)
        .map((x) => CapacitacionCargaMasivaValidado.fromJson(x)));

String capacitacionCargaMasivaValidadoToJson(
        List<CapacitacionCargaMasivaValidado> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CapacitacionCargaMasivaValidado {
  String codigo;
  String dni;
  String nombres;
  String guardia;
  int? codigoEntrenador;
  String entrenador;
  String nombreCapacitacion;
  String categoria;
  String empresa;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  int? horas;
  int? notaTeorica;
  int? notaPractica;
  String mensajeCodigo;
  String mensajeDni;
  String mensajeNombres;
  String mensajeGuardia;
  String mensajeCodigoEntrenador;
  String mensajeEntrenador;
  String mensajeNombreCapacitacion;
  String mensajeCategoria;
  String mensajeEmpresa;
  String mensajeFechaInicio;
  String mensajeFechaTermino;
  String mensajeHoras;
  String mensajeNotaTeorica;
  String mensajeNotaPractica;
  bool esCorrectoCodigo;
  bool esCorrectoDni;
  bool esCorrectoNombres;
  bool esCorrectoGuardia;
  bool esCorrectoCodigoEntrenador;
  bool esCorrectoEntrenador;
  bool esCorrectoNombreCapacitacion;
  bool esCorrectoCategoria;
  bool esCorrectoEmpresa;
  bool esCorrectoFechaInicio;
  bool esCorrectoFechaTermino;
  bool esCorrectoHoras;
  bool esCorrectoNotaTeorica;
  bool esCorrectoNotaPractica;
  bool esValido;

  CapacitacionCargaMasivaValidado({
    this.codigo = '',
    this.dni = '',
    this.nombres = '',
    this.guardia = '',
    this.codigoEntrenador,
    this.entrenador = '',
    this.nombreCapacitacion = '',
    this.categoria = '',
    this.empresa = '',
    this.fechaInicio,
    this.fechaTermino,
    this.horas,
    this.notaTeorica,
    this.notaPractica,
    this.mensajeCodigo = '',
    this.mensajeDni = '',
    this.mensajeNombres = '',
    this.mensajeGuardia = '',
    this.mensajeCodigoEntrenador='',
    this.mensajeEntrenador = '',
    this.mensajeNombreCapacitacion = '',
    this.mensajeCategoria = '',
    this.mensajeEmpresa = '',
    this.mensajeFechaInicio = '',
    this.mensajeFechaTermino = '',
    this.mensajeHoras = '',
    this.mensajeNotaTeorica = '',
    this.mensajeNotaPractica = '',
    this.esCorrectoCodigo=true,
    this.esCorrectoDni=true,
    this.esCorrectoNombres=true,
    this.esCorrectoGuardia=true,
    this.esCorrectoCodigoEntrenador=true,
    this.esCorrectoEntrenador=true,
    this.esCorrectoNombreCapacitacion=true,
    this.esCorrectoCategoria=true,
    this.esCorrectoEmpresa=true,
    this.esCorrectoFechaInicio=true,
    this.esCorrectoFechaTermino=true,
    this.esCorrectoHoras=true,
    this.esCorrectoNotaTeorica=true,
    this.esCorrectoNotaPractica=true,
    this.esValido=true,
  });

  factory CapacitacionCargaMasivaValidado.fromJson(Map<String, dynamic> json) =>
      CapacitacionCargaMasivaValidado(
        codigo: json["Codigo"],
        dni: json["Dni"],
        nombres: json["Nombres"],
        guardia: json["Guardia"],
        codigoEntrenador: json["CodigoEntrenador"],
        entrenador: json["Entrenador"],
        nombreCapacitacion: json["NombreCapacitacion"],
        categoria: json["Categoria"],
        empresa: json["Empresa"],
        fechaInicio: _fromDotNetDate(json["FechaInicio"]),
        fechaTermino: _fromDotNetDate(json["FechaTermino"]),
        horas: json["Horas"],
        notaTeorica: json["NotaTeorica"],
        notaPractica: json["NotaPractica"],
        mensajeCodigo: json["MensajeCodigo"] ?? '',
        mensajeDni: json["MensajeDni"] ?? '',
        mensajeNombres: json["MensajeNombres"] ?? '',
        mensajeGuardia: json["MensajeGuardia"] ?? '',
        mensajeCodigoEntrenador: json["MensajeCodigoEntrenador"] ?? '',
        mensajeEntrenador: json["MensajeEntrenador"] ?? '',
        mensajeNombreCapacitacion: json["MensajeNombreCapacitacion"] ?? '',
        mensajeCategoria: json["MensajeCategoria"] ?? '',
        mensajeEmpresa: json["MensajeEmpresa"] ?? '',
        mensajeFechaInicio: json["MensajeFechaInicio"] ?? '',
        mensajeFechaTermino: json["MensajeFechaTermino"] ?? '',
        mensajeHoras: json["MensajeHoras"] ?? '',
        mensajeNotaTeorica: json["MensajeNotaTeorica"] ?? '',
        mensajeNotaPractica: json["MensajeNotaPractica"] ?? '',
        esCorrectoCodigo: json["EsCorrectoCodigo"],
        esCorrectoDni: json["EsCorrectoDni"],
        esCorrectoNombres: json["EsCorrectoNombres"],
        esCorrectoGuardia: json["EsCorrectoGuardia"],
        esCorrectoCodigoEntrenador: json["EsCorrectoCodigoEntrenador"],
        esCorrectoEntrenador: json["EsCorrectoEntrenador"],
        esCorrectoNombreCapacitacion: json["EsCorrectoNombreCapacitacion"],
        esCorrectoCategoria: json["EsCorrectoCategoria"],
        esCorrectoEmpresa: json["EsCorrectoEmpresa"],
        esCorrectoFechaInicio: json["EsCorrectoFechaInicio"],
        esCorrectoFechaTermino: json["EsCorrectoFechaTermino"],
        esCorrectoHoras: json["EsCorrectoHoras"],
        esCorrectoNotaTeorica: json["EsCorrectoNotaTeorica"],
        esCorrectoNotaPractica: json["EsCorrectoNotaPractica"],
        esValido: json["EsValido"],
      );

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Dni": dni,
        "Nombres": nombres,
        "Guardia": guardia,
        "CodigoEntrenador":codigoEntrenador,
        "Entrenador": entrenador,
        "NombreCapacitacion": nombreCapacitacion,
        "Categoria": categoria,
        "Empresa": empresa,
        "FechaInicio": _toDotNetDate(fechaInicio!),
        "FechaTermino": _toDotNetDate(fechaTermino!),
        "Horas": horas,
        "NotaTeorica": notaTeorica,
        "NotaPractica": notaPractica,
        "MensajeCodigo": mensajeCodigo,
        "MensajeDni": mensajeDni,
        "MensajeNombres": mensajeNombres,
        "MensajeGuardia": mensajeGuardia,
        "MensajeCodigoEntrenador": mensajeCodigoEntrenador,
        "MensajeEntrenador": mensajeEntrenador,
        "MensajeNombreCapacitacion": mensajeNombreCapacitacion,
        "MensajeCategoria": mensajeCategoria,
        "MensajeEmpresa": mensajeEmpresa,
        "MensajeFechaInicio": mensajeFechaInicio,
        "MensajeFechaTermino": mensajeFechaTermino,
        "MensajeHoras": mensajeHoras,
        "MensajeNotaTeorica": mensajeNotaTeorica,
        "MensajeNotaPractica": mensajeNotaPractica,
        "EsCorrectoCodigo": esCorrectoCodigo,
        "EsCorrectoDni": esCorrectoDni,
        "EsCorrectoNombres": esCorrectoNombres,
        "EsCorrectoGuardia": esCorrectoGuardia,
        "EsCorrectoCodigoEntrenador": esCorrectoCodigoEntrenador,
        "EsCorrectoEntrenador": esCorrectoEntrenador,
        "EsCorrectoNombreCapacitacion": esCorrectoNombreCapacitacion,
        "EsCorrectoCategoria": esCorrectoCategoria,
        "EsCorrectoEmpresa": esCorrectoEmpresa,
        "EsCorrectoFechaInicio": esCorrectoFechaInicio,
        "EsCorrectoFechaTermino": esCorrectoFechaTermino,
        "EsCorrectoHoras": esCorrectoHoras,
        "EsCorrectoNotaTeorica": esCorrectoNotaTeorica,
        "EsCorrectoNotaPractica": esCorrectoNotaPractica,
        "EsValido": esValido,
      };

  // Método para deserializar la fecha en formato .NET
  static DateTime _fromDotNetDate(String dotNetDate) {
    final milliseconds = int.parse(dotNetDate.replaceAll(RegExp(r'[^\d]'), ''));
    return DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
  }

  // Método para serializar la fecha de vuelta al formato .NET
  static String _toDotNetDate(DateTime date) {
    return '/Date(${date.millisecondsSinceEpoch})/';
  }
}
