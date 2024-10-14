import 'dart:convert';

List<EntrenamientoConsulta> entrenamientoConsultaFromJson(String str) => List<EntrenamientoConsulta>.from(json.decode(str).map((x) => EntrenamientoConsulta.fromJson(x)));

String entrenamientoConsultaToJson(List<EntrenamientoConsulta> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EntrenamientoConsulta {
  int key;
  int inEntrenamiento;
  String codigoMcp;
  String nombreCompleto;
  Guardia guardia;
  EstadoEntrenamiento estadoEntrenamiento;
  Modulo modulo;
  Entrenador entrenador;
  int notaTeorica;
  int notaPractica;
  int horasAcumuladas;
  Condicion condicion;

  EntrenamientoConsulta({
    required this.key,
    required this.inEntrenamiento,
    required this.codigoMcp,
    required this.nombreCompleto,
    required this.guardia,
    required this.estadoEntrenamiento,
    required this.modulo,
    required this.entrenador,
    required this.notaTeorica,
    required this.notaPractica,
    required this.horasAcumuladas,
    required this.condicion
  });

  factory EntrenamientoConsulta.fromJson(Map<String, dynamic> json) => EntrenamientoConsulta(
    key: json["Key"],
    inEntrenamiento: json["InEntrenamiento"],
    codigoMcp: json["CodigoMcp"],
    nombreCompleto: json["NombreCompleto"],
    guardia: Guardia.fromJson(json["Guardia"]),
    estadoEntrenamiento: EstadoEntrenamiento.fromJson(json["EstadoEntrenamiento"]),
    modulo: Modulo.fromJson(json["Modulo"]),
    entrenador: Entrenador.fromJson(json["Entrenador"]),
    notaTeorica: json["NotaTeorica"],
    notaPractica: json["NotaPractica"],
    horasAcumuladas: json["HorasAcumuladas"],
    condicion: Condicion.fromJson(json["Condicion"]),
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "InEntrenamiento": inEntrenamiento,
    "CodigoMcp": codigoMcp,
    "NombreCompleto": nombreCompleto,
    "Guardia": guardia.toJson(),
    "EstadoEntrenamiento": estadoEntrenamiento.toJson(),
    "Modulo": modulo.toJson(),
    "Entrenador": entrenador.toJson(),
    "NotaTeorica": notaTeorica,
    "NotaPractica": notaPractica,
    "HorasAcumuladas": horasAcumuladas,
    "Condicion": condicion.toJson(),
  };
}
class Guardia {
  int key;
  String nombre;

  Guardia({
    required this.key,
    required this.nombre,
  });

  factory Guardia.fromJson(Map<String, dynamic> json) => Guardia(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
class EstadoEntrenamiento {
  int key;
  String nombre;

  EstadoEntrenamiento({
    required this.key,
    required this.nombre,
  });

  factory EstadoEntrenamiento.fromJson(Map<String, dynamic> json) => EstadoEntrenamiento(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
class Modulo {
  int key;
  String nombre;

  Modulo({
    required this.key,
    required this.nombre,
  });

  factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
class Entrenador {
  int key;
  String nombre;

  Entrenador({
    required this.key,
    required this.nombre,
  });

  factory Entrenador.fromJson(Map<String, dynamic> json) => Entrenador(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
class Condicion {
  int key;
  String nombre;

  Condicion({
    required this.key,
    required this.nombre,
  });

  factory Condicion.fromJson(Map<String, dynamic> json) => Condicion(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}