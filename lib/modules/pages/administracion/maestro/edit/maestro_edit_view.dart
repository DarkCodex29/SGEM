import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/edit/maestro_edit.dart';
import 'package:sgem/shared/widgets/app_button.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';

class MaestroEditView extends StatelessWidget {
  const MaestroEditView({super.key});

  void show() => Get.dialog<void>(this);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(MaestroEditController());

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth > 400 ? 400 : constraints.maxWidth,
              maxHeight:
                  constraints.maxHeight > 800 ? 800 : constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.backgroundBlue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Registro de Maestro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          onPressed: Get.back<void>,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomDropdownGlobal(
                        labelText: 'Maestro',
                        dropdownKey: 'maestro',
                        noDataHintText: 'No se encontraron maestros',
                        hintText: 'Maestro',
                        controller: ctr.dropdownController,
                        textFieldKey:
                            const Key('maestro_edit_dropdown_maestro'),
                      ),
                      CustomTextField(
                        label: 'Valor',
                        controller: ctr.valorController,
                      ),
                      CustomTextField(
                        label: 'Descripción',
                        controller: ctr.descripcionController,
                        maxLines: 3,
                      ),
                      CustomDropdownGlobal(
                        labelText: 'Estado',
                        dropdownKey: 'estado',
                        noDataHintText: 'No se encontraron estados',
                        controller: ctr.dropdownController,
                        hintText: 'Estado',
                        textFieldKey: const Key('maestro_edit_dropdown_estado'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton.white(
                      onPressed: Get.back<void>,
                      text: 'Cerrar',
                    ),
                    AppButton.blue(
                      onPressed: ctr.clearFilter,
                      text: 'Guardar',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
