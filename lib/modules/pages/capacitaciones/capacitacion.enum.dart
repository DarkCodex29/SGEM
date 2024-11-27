enum CapacitacionScreen {
  none,
  nuevaCapacitacion,
  editarCapacitacion,
  visualizarCapacitacion,
  cargaMasivaCapacitacion
}

extension AdministracionScreenExtension on CapacitacionScreen {
  String descripcion() {
    switch (this) {
      case CapacitacionScreen.nuevaCapacitacion:
        return "Nueva Capacitación";
      case CapacitacionScreen.editarCapacitacion:
        return "Editar Capacitación";
      case CapacitacionScreen.visualizarCapacitacion:
        return "Visualizar Capacitación";
      case CapacitacionScreen.cargaMasivaCapacitacion:
        return "Carga masiva de capacitaciones";
      default:
        return "Búsqueda de Capacitaciones";
    }
  }
}