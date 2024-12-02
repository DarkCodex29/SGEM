import 'package:get/get.dart';
import 'package:sgem/config/api/api_rol_permiso.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/shared/dialogs/success_dialog.dart';
import 'package:sgem/shared/models/models.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';

typedef RolPermiso = (Permiso permiso, bool active);

class RolPermisoController extends GetxController {
  RolPermisoController({
    RolPermisoService? api,
  }) : _api = api ?? RolPermisoService();

  final RolPermisoService _api;

  @override
  Future<void> onInit() async {
    super.onInit();
    _getRoles();
    _getPermisos();
  }

  final tabIndex = 0.obs;
  final roles = <Rol>[].obs;

  final permisos = <Permiso>[].obs;

  final _rolFiltro = Rxn<Rol>();
  Rol? get rolFiltro => _rolFiltro.value;
  final permisosFiltrados = <RolPermiso>[].obs;

  final _permisosFiltrados = <Permiso>[].obs;

  final _loading = false.obs;
  bool get loading => _loading.value;

  Future<void> _getRoles() async {
    _loading.value = true;
    try {
      final rolesData = await _api.getRoles();

      if (!rolesData.success) {
        Get.errorSnackbar(rolesData.message ?? 'Error al listar roles');
        return;
      }

      roles.value = rolesData.data!;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _getPermisos() async {
    _loading.value = true;
    try {
      final permisosData = await _api.getPermisos();

      if (!permisosData.success) {
        Get.errorSnackbar(permisosData.message ?? 'Error al listar permisos');
        return;
      }

      permisos.value = permisosData.data!;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> changeRolFiltro(Rol? rol) async {
    _rolFiltro.value = rol;

    if (rol == null) {
      permisosFiltrados.clear();
      return;
    }

    _loading.value = true;
    final permisosData = await _api.getPermisosPorRol(rol: rol.key);
    _loading.value = false;

    if (!permisosData.success) {
      Get.errorSnackbar(permisosData.message ?? 'Error al listar permisos');
      return;
    }

    _permisosFiltrados.value = permisosData.data!;
    final permisosActivos = permisosData.data!.map((p) => p.key);

    permisosFiltrados.value = permisos.map((permiso) {
      final active = permisosActivos.contains(permiso.key);
      return (permiso, active);
    }).toList();
  }

  Future<void> onRolEdit([Rol? rol = null]) async {
    if ((await RolDialog(rol: rol).show()) ?? false) {
      await _getRoles();
    }
  }

  Future<void> onPermisoEdit([Permiso? permiso = null]) async {
    if ((await PermisoDialog(permiso: permiso).show()) ?? false) {
      await _getPermisos();
    }
  }

  /// Send the changes difference to the server
  Future<void> saveRolPermisos() async {
    final rol = rolFiltro;
    if (rol == null) {
      Get.errorSnackbar('Debe seleccionar un rol');
      return;
    }

    final oldActivePermisos = _permisosFiltrados.map((e) => e.key).toSet();
    final newActivePermisos =
        permisosFiltrados.where((e) => e.$2).map((e) => e.$1.key).toSet();

    final toAdd = newActivePermisos.difference(oldActivePermisos);
    final toRemove = oldActivePermisos.difference(newActivePermisos);

    final response = await _api.updateRolPermisos(
      rol: rol.key,
      toAdd: toAdd.toList(),
      toRemove: toRemove.toList(),
    );

    if (!response.success) {
      Get.errorSnackbar(response.message ?? 'Error al actualizar permisos');
      return;
    }

    await const SuccessDialog().show();
    Get.back(result: true);

    await changeRolFiltro(rol);
  }
}
