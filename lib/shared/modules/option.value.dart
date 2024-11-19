class OptionValue {
  OptionValue({
    this.key,
    this.nombre,
  });

  int? key;
  String? nombre;

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
        key: json['Key'] as int,
        nombre: json['Nombre'] as String,
      );

  Map<String, dynamic> toJson() => {
        'Key': key,
        'Nombre': nombre,
      };

  @override
  String toString() => 'OptionValue(key: $key, nombre: $nombre)';
}
