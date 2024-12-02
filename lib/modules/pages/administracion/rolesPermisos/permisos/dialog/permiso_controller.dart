part of 'permiso_dialog.dart';

class PermisoController extends GetxController {
  PermisoController({
    this.permiso,
    RolPermisoService? api,
  }) : _api = api ?? RolPermisoService();

  final RolPermisoService _api;
  final Permiso? permiso;

  @override
  Future<void> onInit() async {
    super.onInit();
    name.text = permiso?.name ?? '';
    active.value = permiso?.actived;
    code.text = permiso?.code ?? '';
  }

  @override
  void onClose() {
    name.dispose();
    code.dispose();
    super.onClose();
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController code = TextEditingController();
  final active = Rxn<bool>();

  Future<void> updatePermiso() async {
    final activeValue = active.value;
    if (activeValue == null) {
      Get.errorSnackbar('Debe seleccionar si el permiso está activo o no');
      return;
    }

    final nameValue = name.text.trim();
    if (nameValue.isEmpty) {
      Get.errorSnackbar('Debe ingresar el nombre del permiso');
      return;
    }

    if (permiso == null) {
      Get.errorSnackbar('Error al actualizar permiso');
      return;
    }

    final codeValue = code.text.trim();
    if (codeValue.isEmpty) {
      Get.errorSnackbar('Debe ingresar el código del permiso');
      return;
    }

    final permisoUpdated = Permiso(
      key: permiso!.key,
      code: codeValue,
      name: nameValue,
      userRegister: permiso!.userRegister,
      actived: activeValue,
    );

    final response = await _api.updatePermiso(permisoUpdated);

    if (!response.success) {
      Get.errorSnackbar(response.message ?? 'Error al crear permiso');
      return;
    }

    Get.back(result: true);
  }

  Future<void> savePermiso() async {
    final activeValue = active.value;
    if (activeValue == null) {
      Get.errorSnackbar('Debe seleccionar si el permiso está activo o no');
      return;
    }

    final nameValue = name.text.trim();
    if (nameValue.isEmpty) {
      Get.errorSnackbar('Debe ingresar el nombre del permiso');
      return;
    }

    final permiso = Permiso(
      name: nameValue,
      code: code.text.trim(),
      userRegister: 'admin',
      actived: activeValue,
    );

    final response = await _api.registratePermiso(permiso);

    if (!response.success) {
      Get.errorSnackbar(response.message ?? 'Error al crear permiso');
      return;
    }

    Get.back(result: true);
  }
}
