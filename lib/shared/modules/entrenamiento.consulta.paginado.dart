import 'dart:convert';

EntrenamientoConsultaPaginado entrenamientoConsultaPaginadoFromJson(String str) => EntrenamientoConsultaPaginado.fromJson(json.decode(str));

String entrenamientoConsultaPaginadoToJson(EntrenamientoConsultaPaginado data) => json.encode(data.toJson());

class EntrenamientoConsultaPaginado {
  List<Item> items;
  int pageNumber;
  int pageSize;
  int totalRecords;
  int totalPages;

  EntrenamientoConsultaPaginado({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory EntrenamientoConsultaPaginado.fromJson(Map<String, dynamic> json) => EntrenamientoConsultaPaginado(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    pageNumber: json["PageNumber"],
    pageSize: json["PageSize"],
    totalRecords: json["TotalRecords"],
    totalPages: json["TotalPages"],
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalRecords": totalRecords,
    "TotalPages": totalPages,
  };
}

class Item {
  int key;
  int inEntrenamiento;
  String codigoMcp;
  String nombreCompleto;
  Entrenador guardia;
  Entrenador estadoEntrenamiento;
  Entrenador modulo;
  Entrenador entrenador;
  int notaTeorica;
  int notaPractica;
  int horasAcumuladas;

  Item({
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
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    key: json["Key"],
    inEntrenamiento: json["InEntrenamiento"],
    codigoMcp: json["CodigoMcp"],
    nombreCompleto: json["NombreCompleto"],
    guardia: Entrenador.fromJson(json["Guardia"]),
    estadoEntrenamiento: Entrenador.fromJson(json["EstadoEntrenamiento"]),
    modulo: Entrenador.fromJson(json["Modulo"]),
    entrenador: Entrenador.fromJson(json["Entrenador"]),
    notaTeorica: json["NotaTeorica"],
    notaPractica: json["NotaPractica"],
    horasAcumuladas: json["HorasAcumuladas"],
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
