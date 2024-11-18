import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/edit/maestro_edit.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/widgets/app_button.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';

class MaestroEditView extends StatelessWidget {
  const MaestroEditView({
    super.key,
    this.detalle,
  });

  final MaestroDetalle? detalle;

  void show() => Get.dialog<void>(this);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(MaestroEditController(detalle));
    final isEdit = detalle != null;

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
              maxWidth: constraints.maxWidth > 500 ? 500 : constraints.maxWidth,
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
                      Text(
                        isEdit ? 'Editar Maestro' : 'Registro de Maestro',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                  child: Obx(
                    () {
                      return Column(
                        children: [
                          if (isEdit)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Código: ${detalle!.key!.format}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const AppDropdownField(
                            dropdownKey: 'maestro',
                            label: 'Maestro',
                          ),
                          CustomTextField(
                            label: 'Valor',
                            isRequired: true,
                            controller: ctr.valorController,
                          ),
                          CustomTextField(
                            label: 'Descripción',
                            controller: ctr.descripcionController,
                            maxLines: 3,
                          ),
                          const AppDropdownField(
                            label: 'Estado',
                            isRequired: true,
                            dropdownKey: 'estado',
                            // noDataHintText: 'No se encontraron estados',
                            // controller: ctr.dropdownController,
                            // hintText: 'Estado',
                            key: const Key('maestro_edit_dropdown_estado'),
                          ),
                        ],
                      );
                    },
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
                      onPressed: ctr.save,
                      text: 'Guardar',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
