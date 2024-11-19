import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.modulo.dart';
import 'package:sgem/config/api/api.modulo.detail.dart';
import 'package:sgem/shared/modules/modulo.detail.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class ModuloController extends GetxController {
  ModuloController({
    ModuloService? moduloService,
    ModuloDetalleService? moduloDetalleService,
  })  : _moduloService = moduloService ?? ModuloService(),
        _moduloDetalleService =
            moduloDetalleService ?? ModuloDetalleService();

  @override
  Future<void> onInit() async {
    initializeDropdown();
    await search();
    super.onInit();
  }

  final ModuloService _moduloService;
  final ModuloDetalleService _moduloDetalleService;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  final modulos = <OptionValue>[].obs;
  void initializeDropdown() {
    dropdownController
      ..initializeDropdown('modulo')
      ..loadOptions('modulo', getModulos)
      ..initializeDropdown('estado_m')
      ..loadOptions('estado_m', () async {
        return [
          OptionValue(key: 1, nombre: 'Activo'),
          OptionValue(key: 2, nombre: 'Inactivo'),
        ];
      });
  }

  final TextEditingController valorController = TextEditingController();
  static final _allModulo = OptionValue(key: 0, nombre: 'Todos');

  void clearFilter() {
    debugPrint('Clear filter');
    valorController.clear();
    dropdownController
      ..resetSelection('modulo')
      ..resetSelection('estado_m');
  }

  final result = <ModuloDetalle>[].obs;
  final rowsPerPage = 10.obs;

  Future<List<OptionValue>?> getModulos() async {
    final response = await _moduloService.getModulos();
    if (!response.success) {
      Get.snackbar(
        'Error',
        'Error al cargar los modulos',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (response.data != null) {
      modulos.value = [_allModulo, ...response.data!];
    }

    return response.data;
  }

  Future<void> search() async {
    final moduloKey = dropdownController.getSelectedValue('modulo')?.key;
    final estado = dropdownController.getSelectedValue('estado_m')?.key;
    final valor = valorController.text;

    final response = await _moduloDetalleService.getModuloDetalles(
      moduloKey: moduloKey == 0 ? null : moduloKey,
      value: valor.isEmpty ? null : valor,
      status: estado,
    );

    if (response.success) {
      debugPrint('Result: ${response.data!.length}');
      result.assignAll(response.data!);
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'Error al cargar los modulos',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
