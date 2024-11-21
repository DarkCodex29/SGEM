import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/shared/modules/modulo_model.dart';
import 'package:sgem/shared/widgets/app_button.dart';
import 'package:sgem/shared/widgets/app_text_field.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';

class ModuloEditView extends StatelessWidget {
  const ModuloEditView({
    required this.modulo,
    super.key,
  });

  final Modulo modulo;

  Future<bool?> show() async => Get.dialog<bool>(this);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(ModuloEditController(modulo));

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
                      const Text(
                        'Editar Modulo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                  child: Column(
                    children: [
                      Text(
                        modulo.module,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppTextField(
                        label: 'Horas de Cumplimiento',
                        isRequired: true,
                        controller: ctr.hourController,
                      ),
                      AppTextField(
                        label: 'Nota Mínima Aprobatoria',
                        isRequired: true,
                        controller: ctr.minGradeController,
                      ),
                      AppTextField(
                        label: 'Nota Máxima',
                        controller: ctr.maxGradeController,
                        isRequired: true,
                        maxLines: 3,
                      ),
                      const AppDropdownField(
                        label: 'Estado',
                        isRequired: true,
                        dropdownKey: 'estado_modulos',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton.white(
                      onPressed: () => Get.back<bool>(result: false),
                      text: 'Cerrar',
                    ),
                    AppButton.blue(
                      onPressed: ctr.updateModulo,
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
