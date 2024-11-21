import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/shared/dialogs/confirm_dialog.dart';
import 'package:sgem/shared/dialogs/success_dialog.dart';
import 'package:sgem/shared/modules/modulo_model.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class ModuloEditController extends GetxController {
  ModuloEditController(
    this.modulo, {
    ModuloMaestroService? moduloService,
  }) : _moduloService = moduloService ?? ModuloMaestroService();

  @override
  Future<void> onInit() async {
    initializeDropdown();
    super.onInit();
  }

  final ModuloMaestroService _moduloService;
  final Modulo modulo;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  void initializeDropdown() {
    dropdownController
      ..loadOptions(
        'estado_modulos',
        () async => [
          const OptionValue(key: 1, nombre: 'Activo'),
          const OptionValue(key: 0, nombre: 'Inactivo'),
        ],
      )
      ..selectValueByKey(
        options: 'estado_modulos',
        optionKey: modulo.status ? 1 : 0,
      );
  }

  final TextEditingController hourController = TextEditingController();
  final TextEditingController minGradeController = TextEditingController();
  final TextEditingController maxGradeController = TextEditingController();

  void clearFilter() {
    hourController.clear();
    minGradeController.clear();
    maxGradeController.clear();
    dropdownController.resetSelection('estado_modulos');
  }

  bool _validate({
    required String hours,
    required String minGrade,
    required String maxGrade,
    required OptionValue? status,
  }) {
    final errors = <String>[];
    if (hours.isEmpty) {
      errors.add('El campo Horas de Cumplimiento es obligatorio');
    } else if (int.tryParse(hours) == null) {
      errors.add('El campo Horas de Cumplimiento is inválido');
    }

    if (minGrade.isEmpty) {
      errors.add('El campo Nota Mínima Aprobatoria es obligatorio');
    } else if (int.tryParse(minGrade) == null) {
      errors.add('El campo Nota Mínima Aprobatoria es inválido');
    }

    if (maxGrade.isNotEmpty && int.tryParse(maxGrade) == null) {
      errors.add('El campo Nota Máxima es inválido');
    }

    if (status == null) {
      errors.add('El campo Estado es obligatorio');
    }

    if (errors.isNotEmpty) {
      Get.errorSnackbar(errors.join('\n'));
      return false;
    }

    return true;
  }

  Future<void> updateModulo() async {
    final hours = hourController.text;
    final minGrade = minGradeController.text;
    final maxGrade = maxGradeController.text;
    final status = dropdownController.getSelectedValue('estado_modulos');

    if (!_validate(
      hours: hours,
      minGrade: minGrade,
      maxGrade: maxGrade,
      status: status,
    )) return;

    final confirm = await const ConfirmDialog().show();

    if (!(confirm ?? false)) return;

    final response = await _moduloService.updateModulo(
      modulo.copyWith(
        hours: int.parse(hours),
        minGrade: int.parse(minGrade),
        maxGrade: maxGrade.isNotEmpty ? int.parse(maxGrade) : null,
        status: status!.key == 1,
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
}
