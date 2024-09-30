import 'dart:convert';

class EntidadSesion {
  String inSesion;
  String inPersona;
  String vcApellidoPaterno;
  String vcApellidoMaterno;
  String vcPrimerNombre;
  String vcSegundoNombre;
  String vcCorreoInstitucional;
  String vcToken;
  String dtInicioValidez;
  String dtFinValidez;
  String vcCrea;
  String dtRegistro;

  EntidadSesion({
    this.inSesion = '',
    this.inPersona = '',
    this.vcApellidoPaterno = '',
    this.vcApellidoMaterno = '',
    this.vcPrimerNombre = '',
    this.vcSegundoNombre = '',
    this.vcCorreoInstitucional = '',
    this.vcToken = '',
    this.dtInicioValidez = '',
    this.dtFinValidez = '',
    this.vcCrea = '',
    this.dtRegistro = '',
  });

  EntidadSesion copyWith({
    String? inSesion,
    String? inPersona,
    String? vcApellidoPaterno,
    String? vcApellidoMaterno,
    String? vcPrimerNombre,
    String? vcSegundoNombre,
    String? vcCorreoInstitucional,
    String? vcToken,
    String? dtInicioValidez,
    String? dtFinValidez,
    String? vcCrea,
    String? dtRegistro,
  }) =>
      EntidadSesion(
        inSesion: inSesion ?? this.inSesion,
        inPersona: inPersona ?? this.inPersona,
        vcApellidoPaterno: vcApellidoPaterno ?? this.vcApellidoPaterno,
        vcApellidoMaterno: vcApellidoMaterno ?? this.vcApellidoMaterno,
        vcPrimerNombre: vcPrimerNombre ?? this.vcPrimerNombre,
        vcSegundoNombre: vcSegundoNombre ?? this.vcSegundoNombre,
        vcCorreoInstitucional:
            vcCorreoInstitucional ?? this.vcCorreoInstitucional,
        vcToken: vcToken ?? this.vcToken,
        dtInicioValidez: dtInicioValidez ?? this.dtInicioValidez,
        dtFinValidez: dtFinValidez ?? this.dtFinValidez,
        vcCrea: vcCrea ?? this.vcCrea,
        dtRegistro: dtRegistro ?? this.dtRegistro,
      );

  factory EntidadSesion.fromMap(Map<String, dynamic> json) => EntidadSesion(
        inSesion: json["inSesion"] ?? "",
        inPersona: json["inPersona"] ?? "",
        vcApellidoPaterno: json["vcApellidoPaterno"] ?? "",
        vcApellidoMaterno: json["vcApellidoMaterno"] ?? "",
        vcPrimerNombre: json["vcPrimerNombre"] ?? "",
        vcSegundoNombre: json["vcSegundoNombre"] ?? "",
        vcCorreoInstitucional: json["vcCorreoInstitucional"] ?? "",
        vcToken: json["vcToken"] ?? "",
        dtInicioValidez: json["dtInicioValidez"] ?? "",
        dtFinValidez: json["dtFinValidez"] ?? "",
        vcCrea: json["vcCrea"] ?? "",
        dtRegistro: json["dtRegistro"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "inSesion": inSesion,
        "inPersona": inPersona,
        "vcApellidoPaterno": vcApellidoPaterno,
        "vcApellidoMaterno": vcApellidoMaterno,
        "vcPrimerNombre": vcPrimerNombre,
        "vcSegundoNombre": vcSegundoNombre,
        "vcCorreoInstitucional": vcCorreoInstitucional,
        "vcToken": vcToken,
        "dtInicioValidez": dtInicioValidez,
        "dtFinValidez": dtFinValidez,
        "vcCrea": vcCrea,
        "dtRegistro": dtRegistro,
      };

  factory EntidadSesion.fromJson(String str) =>
      EntidadSesion.fromMap(json.decode(str));

  String toJson(EntidadSesion data) => json.encode(data.toMap());
}
