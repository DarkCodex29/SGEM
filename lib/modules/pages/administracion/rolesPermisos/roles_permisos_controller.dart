import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.roles.permisos.dart';
import 'package:sgem/config/api/api_rol_permiso.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/roles.dart';
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
}
