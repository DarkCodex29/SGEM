enum AdministracionScreen {
  none._('Administración'),
  maestro._('Mantenimiento de maestros'),
  modulos._('Mantenimiento de módulos'),
  rolesPermisos._('Roles y permisos'),
  usuarios._('Lista de usuarios');

  const AdministracionScreen._(this.pageName);

  final String pageName;
}
