enum MaestroDetalleTypes {
  tipoActividad,
  guardia,
  condicionEntrenamiento,
  estadoEntrenamiento,
  equipo,
  condicionMonitoreo,
  capacitaciones,
  empresaCapacitadora,
  categoriaCapacitacion,
}

extension MaestroDetalleTypesExtension on MaestroDetalleTypes {
  int get rawValue {
    switch (this) {
      case MaestroDetalleTypes.tipoActividad:
        return 1;
      case MaestroDetalleTypes.guardia:
        return 2;
      case MaestroDetalleTypes.condicionEntrenamiento:
        return 3;
      case MaestroDetalleTypes.estadoEntrenamiento:
        return 4;
      case MaestroDetalleTypes.equipo:
        return 5;
      case MaestroDetalleTypes.condicionMonitoreo:
        return 6;
      case MaestroDetalleTypes.capacitaciones:
        return 7;
      case MaestroDetalleTypes.empresaCapacitadora:
        return 8;
      case MaestroDetalleTypes.categoriaCapacitacion:
        return 9;
    }
  }
}
