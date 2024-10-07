import 'package:sgem/shared/modules/maestro.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';

class MaestroDetalle implements DropdownElement {
  int key;
  MaestroBasico maestro;
  String? valor;
  String? usuarioRegistro;
  DateTime? fechaRegistro;
  String? usuarioModifica;
  DateTime? fechaModifica;
  String? activo;

   
  @override
  String get value => valor ?? "none";

  @override
  int get id => key ;

  
  MaestroDetalle({
    required this.key,
    required this.maestro,
    required this.valor,
    this.usuarioRegistro,
    required this.fechaRegistro,
    this.usuarioModifica,
    this.fechaModifica,
    required this.activo,
  });

  factory MaestroDetalle.fromJson(Map<String, dynamic> json) {
    return MaestroDetalle(
      key: json['Key'] ?? 0,
      maestro: MaestroBasico.fromJson(json['Maestro']),
      valor: json['Valor'] ?? 'Desconocido',
      usuarioRegistro: json['UsuarioRegistro'] ?? 'Desconocido',
      fechaRegistro: MaestroCompleto.parseDateNullable(json['FechaRegistro']),
      usuarioModifica: json['UsuarioModifica']?.isNotEmpty == true
          ? json['UsuarioModifica']
          : 'Desconocido',
      fechaModifica: json['FechaModifica'] != null
          ? MaestroCompleto.parseDate(json['FechaModifica'] ?? "")
          : null,
      activo: json['Activo'] ?? 'N',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Maestro': maestro.toJson(),
      'Valor': valor,
      'UsuarioRegistro': usuarioRegistro,
      'FechaRegistro': MaestroCompleto.toJsonDateNullable(fechaRegistro),
      'UsuarioModifica': usuarioModifica,
      'FechaModifica': MaestroCompleto.toJsonDateNullable(fechaModifica),
      'Activo': activo,
    };
  }
}


