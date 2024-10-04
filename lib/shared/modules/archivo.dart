import 'dart:convert';

List<Archivo> archivoFromJson(String str) => List<Archivo>.from(json.decode(str).map((x) => Archivo.fromJson(x)));

String archivoToJson(List<Archivo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Archivo {
  int key;
  String nombre;
  String extension;
  String mime;
  List<int> datos;
  int inTipoArchivo;
  int inOrigen;
  int inOrigenKey;

  Archivo({
    required this.key,
    required this.nombre,
    required this.extension,
    required this.mime,
    required this.datos,
    required this.inTipoArchivo,
    required this.inOrigen,
    required this.inOrigenKey,
  });

  factory Archivo.fromJson(Map<String, dynamic> json) => Archivo(
    key: json["Key"],
    nombre: json["Nombre"],
    extension: json["Extension"],
    mime: json["Mime"],
    datos: List<int>.from(json["Datos"].map((x) => x)),
    inTipoArchivo: json["InTipoArchivo"],
    inOrigen: json["InOrigen"],
    inOrigenKey: json["InOrigenKey"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
    "Extension": extension,
    "Mime": mime,
    "Datos": List<dynamic>.from(datos.map((x) => x)),
    "InTipoArchivo": inTipoArchivo,
    "InOrigen": inOrigen,
    "InOrigenKey": inOrigenKey,
  };
}
