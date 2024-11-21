import 'package:flutter/foundation.dart';

@immutable
class OptionValue {
  const OptionValue({
    this.key,
    this.nombre,
  });

  final int? key;
  final String? nombre;

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
        key: json['Key'] as int?,
        nombre: json['Nombre'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'Key': key,
        'Nombre': nombre,
      };

  @override
  String toString() => 'OptionValue(key: $key, nombre: $nombre)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OptionValue && other.key == key && other.nombre == nombre;
  }

  @override
  int get hashCode => key.hashCode ^ nombre.hashCode;
}
