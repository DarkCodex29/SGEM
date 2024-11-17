import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.maestro.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class MaestroEditController extends GetxController {
  MaestroEditController({
    MaestroService? maestroService,
    MaestroDetalleService? maestroDetalleService,
  })  : _maestroService = maestroService ?? MaestroService(),
        _maestroDetalleService =
            maestroDetalleService ?? MaestroDetalleService();

  @override
  Future<void> onInit() async {
    initializeDropdown();
    super.onInit();
  }

  final MaestroService _maestroService;
  final MaestroDetalleService _maestroDetalleService;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  void initializeDropdown() {
    dropdownController
      ..loadOptions('maestro', getMaestros)
      ..resetSelection('maestro')
      ..resetSelection('estado');
  }

  final TextEditingController valorController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  void clearFilter() {
    valorController.clear();
    descripcionController.clear();
    dropdownController
      ..resetSelection('maestro')
      ..selectValueKey('maestro', 0)
      ..resetSelection('estado');
  }

  Future<List<OptionValue>?> getMaestros() async {
    final response = await _maestroService.getMaestros();
    if (!response.success) {
      Get.snackbar(
        'Error',
        'Error al cargar los maestros',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return response.data;
  }

  Future<void> save() async {
    // final response = await _maestroDetalleService.save(
    //   valor: valorController.text,
    //   descripcion: descripcionController.text,
    //   estado: dropdownController.getValueKey('estado'),
    //   maestro: dropdownController.getValueKey('maestro'),
    // );
    //
    // if (response.success) {
    //   Get.back<void>();
    //   Get.snackbar(
    //     'Guardado',
    //     'Registro guardado correctamente',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } else {
    //   Get.snackbar(
    //     'Error',
    //     'Error al guardar el registro',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
  }
}
