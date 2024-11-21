import 'package:flutter/material.dart';
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
    valorController.text = detalle?.valor ?? '';
    descripcionController.text = detalle?.descripcion ?? '';
    dropdownController
      ..loadOptions('maestro_2', getMaestros)
      ..loadOptions(
        'estado_2',
        () async => [
          const OptionValue(key: 1, nombre: 'Activo'),
          const OptionValue(key: 0, nombre: 'Inactivo'),
        ],
      );

    if (detalle != null) {
      if (detalle!.activo != null) {
        dropdownController.selectValueByKey(
          options: 'estado_2',
          optionKey: detalle!.activo == 'S' ? 1 : 0,
        );
      }

      dropdownController.selectValueByKey(
        options: 'maestro_2',
        optionKey: detalle!.maestro.key,
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

  bool _validate({
    required String valor,
    required OptionValue? maestro,
    required String descripcion,
    required OptionValue? estado,
  }) {
    final errors = <String>[];
    if (valor.isEmpty) {
      errors.add('El campo valor es obligatorio');
    } else if (valor.length > 50) {
      errors.add('El campo valor no puede tener más de 50 caracteres');
    }

    if (maestro == null) {
      errors.add('El campo maestro es obligatorio');
    }

    if (descripcion.length > 200) {
      errors.add('El campo descripción no puede tener más de 200 caracteres');
    }

    if (estado == null) {
      errors.add('El campo estado es obligatorio');
    }

    if (errors.isNotEmpty) {
      Get.snackbar(
        'Error',
        errors.join('\n'),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return false;
    }

    return true;
  }

  Future<void> saveDetalle() async {
    final valor = valorController.text;
    final maestro = dropdownController.getSelectedValue('maestro_2');
    final descripcion = descripcionController.text;
    final estado = dropdownController.getSelectedValue('estado_2');

    if (!_validate(
      valor: valor,
      maestro: maestro,
      descripcion: descripcion,
      estado: estado,
    )) return;

    final confirm = await const ConfirmDialog().show();

    if (!(confirm ?? false)) return;

    final response = await _maestroDetalleService.registrateMaestroDetalle(
      MaestroDetalle(
        valor: valor,
        activo: switch (estado!.key!) {
          1 => 'S',
          0 => 'N',
          _ => throw Exception('Estado no válido'),
        },
        maestro: MaestroBasico(
          key: maestro!.key!,
          nombre: maestro.nombre,
        ),
        key: null,
        fechaRegistro: DateTime.now(),
        usuarioRegistro: 'ldolorier',
      ),
    );

    if (response.success) {
      Get.back<void>();
      await const SuccessDialog().show();
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'Error al guardar el registro',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> updateDetalle() async {
    final valor = valorController.text;
    final maestro = dropdownController.getSelectedValue('maestro_2');
    final descripcion = descripcionController.text;
    final estado = dropdownController.getSelectedValue('estado_2');

    if (!_validate(
      valor: valor,
      maestro: maestro,
      descripcion: descripcion,
      estado: estado,
    )) return;

    final confirm = await const ConfirmDialog().show();

    if (!(confirm ?? false)) return;

    final newDetalle = MaestroDetalle(
      valor: valor,
      activo: switch (estado!.key!) {
        1 => 'S',
        0 => 'N',
        _ => throw Exception('Estado no válido'),
      },
      maestro: MaestroBasico(
        key: maestro!.key!,
        nombre: maestro.nombre,
      ),
      key: detalle!.key,
      usuarioModifica: 'ldolorier',
      fechaRegistro: DateTime.now(),
    );

    final response =
        await _maestroDetalleService.updateMaestroDetalle(newDetalle);

    if (response.success) {
      Get.back<void>();
      await const SuccessDialog().show();
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'Error al actualizar el registro',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }
}
