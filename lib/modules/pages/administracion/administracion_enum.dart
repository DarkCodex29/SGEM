enum AdministracionScreen {
  none._('Administración'),
  maestro._('Mantenimiento de maestros'),
  modulos._('Mantenimiento de módulos'),
  ;

  const AdministracionScreen._(this.pageName);

  final String pageName;
}
