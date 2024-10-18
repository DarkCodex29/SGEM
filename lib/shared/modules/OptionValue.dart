class OptionValue {
  int? key;
  String? nombre;

  OptionValue({
    this.key,
    this.nombre,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
    key: json["Key"],
    nombre: json["Nombre"],
  );

  Map<String, dynamic> toJson() => {
    "Key": key,
    "Nombre": nombre,
  };
}
