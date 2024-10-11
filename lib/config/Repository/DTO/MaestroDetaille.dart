enum MaestroDetalleTypes { equipo, condition }

extension MaestroDetalleTypesExtension on MaestroDetalleTypes {
  int get rawValue {
    switch (this) {
      case MaestroDetalleTypes.equipo:
        return 5;
      case MaestroDetalleTypes.condition:
        return 3;
    }
  }
}
