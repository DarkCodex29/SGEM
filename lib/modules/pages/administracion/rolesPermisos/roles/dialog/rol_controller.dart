part of 'rol_dialog.dart';

class RolController extends GetxController {
  RolController({
    this.rol,
    RolPermisoService? api,
  }) : _api = api ?? RolPermisoService();

  final RolPermisoService _api;
  final Rol? rol;

  @override
  Future<void> onInit() async {
    super.onInit();
    name.text = rol?.name ?? '';
    active.value = rol?.actived;
  }

  final TextEditingController name = TextEditingController();
  final active = Rxn<bool>();

  Future<void> updateRol() async {
    final activeValue = active.value;
    if (activeValue == null) {
      Get.errorSnackbar('Debe seleccionar si el rol está activo o no');
      return;
    }

    final nameValue = name.text.trim();
    if (nameValue.isEmpty) {
      Get.errorSnackbar('Debe ingresar el nombre del rol');
      return;
    }

    if (rol == null) {
      Get.errorSnackbar('Error al actualizar rol');
      return;
    }

    final rolUpdated = Rol(
      key: rol!.key,
      name: nameValue,
      dateRegister: rol!.dateRegister,
      userRegister: rol!.userRegister,
      actived: activeValue,
    );

    final response = await _api.updateRol(rolUpdated);

    if (!response.success) {
      Get.errorSnackbar(response.message ?? 'Error al crear rol');
      return;
    }

    await const SuccessDialog().show();
    Get.back(result: true);
  }

  Future<void> saveRol() async {
    final activeValue = active.value;
    if (activeValue == null) {
      Get.errorSnackbar('Debe seleccionar si el rol está activo o no');
      return;
    }

    final nameValue = name.text.trim();
    if (nameValue.isEmpty) {
      Get.errorSnackbar('Debe ingresar el nombre del rol');
      return;
    }

    final rol = Rol(
      name: nameValue,
      dateRegister: DateTime.now(),
      userRegister: 'admin',
      actived: activeValue,
    );

    final response = await _api.registrateRol(rol);

    if (!response.success) {
      Get.errorSnackbar(response.message ?? 'Error al crear rol');
      return;
    }

    await const SuccessDialog().show();
    Get.back(result: true);
  }
}
