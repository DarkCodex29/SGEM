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
    await buscarMaestroDetalle();
    super.onInit();
  }

  final MaestroService _maestroService;
  final MaestroDetalleService _maestroDetalleService;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  void initializeDropdown() {
    dropdownController
      ..initializeDropdown('maestro')
      ..loadOptions('maestro', () async {
        final response = await _maestroService.getMaestros();
        if (!response.success) {
          Get.snackbar(
            'Error',
            'Error al cargar los maestros',
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        return response.data?..add(OptionValue(key: 0, nombre: 'Todos'));
      })
      ..initializeDropdown('estado')
      ..loadOptions('estado', () async {
        return [
          OptionValue(key: 0, nombre: 'Activo'),
          OptionValue(key: 1, nombre: 'Inactivo'),
        ];
      });
  }

  final TextEditingController valorController = TextEditingController();

  void clearFilter() {
    valorController.clear();
    dropdownController
      ..resetSelection('maestro')
      ..resetSelection('estado');
  }

  final result = <MaestroDetalle>[].obs;
  final rowsPerPage = 10.obs;

  Future<void> buscarMaestroDetalle() async {
    final response = await _maestroDetalleService.getMaestroDetalles();

    if (response.success) {
      result.assignAll(response.data!);
    } else {
      Get.snackbar(
        'Error',
        'Error al cargar los maestros',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
