import 'package:get/get.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/shared/modules/modulo_model.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';

class ModuloController extends GetxController {
  ModuloController({
    ModuloMaestroService? moduloService,
  }) : _moduloService = moduloService ?? ModuloMaestroService();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  final ModuloMaestroService _moduloService;

  final modulos = <Modulo>[].obs;

  Future<void> getModulos() async {
    final response = await _moduloService.getModules();
    if (!response.success) {
      return Get.errorSnackbar(
        response.message ?? 'Error al obtener los módulos',
      );
    }

    modulos.assignAll(response.data!);
  }
}
