import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.maestro.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/shared/dialogs/confirm_dialog.dart';
import 'package:sgem/shared/dialogs/success_dialog.dart';
import 'package:sgem/shared/modules/maestro.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class MaestroEditController extends GetxController {
  MaestroEditController(
    this.detalle, {
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
  final MaestroDetalle? detalle;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  void initializeDropdown() {
    dropdownController
      ..loadOptions('maestro', getMaestros)
      ..resetSelection('maestro')
      ..resetSelection('estado');

    if (detalle != null) {
      dropdownController.selectValueByKey(
        options: 'estado',
        optionKey: detalle!.activo == 'S' ? 0 : 1,
      );
    }
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
    String? error;
    final valor = valorController.text;
    if (valor.isEmpty) {
      error = 'El campo valor es obligatorio';
    } else if (valor.length > 50) {
      error = 'El campo valor no puede tener más de 50 caracteres';
    }

    final maestro = dropdownController.getSelectedValue('maestro');
    if (maestro == null) {
      error = 'El campo maestro es obligatorio';
    }

    final descripcion = descripcionController.text;
    if (descripcion.length > 200) {
      error = 'El campo descripción no puede tener más de 200 caracteres';
    }

    final estado = dropdownController.getSelectedValue('estado');
    if (estado == null) {
      error = 'El campo estado es obligatorio';
    }

    if (error != null) {
      Get.snackbar(
        'Error',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final confirm = await const ConfirmDialog().show();

    if (!(confirm ?? false)) return;

    // final response = await _maestroDetalleService.registrarMaestroDetalle(
    //   MaestroDetalle(
    //     valor: valor,
    //     activo: switch (estado!.key!) {
    //       0 => 'S',
    //       1 => 'N',
    //       _ => throw Exception('Estado no válido'),
    //     },
    //     maestro: MaestroBasico(
    //       key: maestro!.key!,
    //       nombre: maestro.nombre,
    //     ),
    //     key: null,
    //     fechaRegistro: DateTime.now(),
    //   ),
    // );

    if (true) {
      Get.back<void>();
      await const SuccessDialog().show();
    } else {
      Get.snackbar(
        'Error',
        'Error al guardar el registro',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
