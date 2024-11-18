import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.maestro.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class MaestroController extends GetxController {
  MaestroController({
    MaestroService? maestroService,
    MaestroDetalleService? maestroDetalleService,
  })  : _maestroService = maestroService ?? MaestroService(),
        _maestroDetalleService =
            maestroDetalleService ?? MaestroDetalleService();

  @override
  Future<void> onInit() async {
    initializeDropdown();
    await search();
    super.onInit();
  }

  final MaestroService _maestroService;
  final MaestroDetalleService _maestroDetalleService;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  final maestros = <OptionValue>[].obs;
  void initializeDropdown() {
    dropdownController
      ..initializeDropdown('maestro')
      ..loadOptions('maestro', getMaestros)
      ..initializeDropdown('estado')
      ..loadOptions(
        'estado',
        () async => const [
          OptionValue(key: 0, nombre: 'Activo'),
          OptionValue(key: 1, nombre: 'Inactivo'),
        ],
      );
  }

  final TextEditingController valorController = TextEditingController();
  static const _allMaestro = OptionValue(key: 0, nombre: 'Todos');

  void clearFilter() {
    debugPrint('Clear filter');
    valorController.clear();
    dropdownController
      ..resetSelection('maestro')
      // ..selectValue('maestro', _allMaestro)
      ..resetSelection('estado');
  }

  final result = <MaestroDetalle>[].obs;
  final rowsPerPage = 10.obs;

  Future<List<OptionValue>?> getMaestros() async {
    final response = await _maestroService.getMaestros();
    if (!response.success) {
      Get.snackbar(
        'Error',
        'Error al cargar los maestros',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (response.data != null) {
      maestros
        ..assignAll(response.data!)
        ..insert(0, _allMaestro);
    }

    return response.data;
  }

  Future<void> search() async {
    final maestroKey = dropdownController.getSelectedValue('maestro')?.key;
    final estado = dropdownController.getSelectedValue('estado')?.key;
    final valor = valorController.text;

    final response = await _maestroDetalleService.getMaestroDetalles(
      maestroKey: maestroKey == 0 ? null : maestroKey,
      value: valor.isEmpty ? null : valor,
      status: estado,
    );

    if (response.success) {
      result.assignAll(response.data!);
      clearFilter();
    } else {
      Get.snackbar(
        'Error',
        'Error al cargar los maestros',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
