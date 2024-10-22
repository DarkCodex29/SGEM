enum AdministracionScreen {
  none,
  maestro,
}

extension AdministracionScreenExtension on AdministracionScreen {
  String descripcion() {
    switch (this) {
      case AdministracionScreen.maestro:
        return "Mantenimiento de maestros";
      default:
        return "Administración";
    }
  }
}