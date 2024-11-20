import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/edit/maestro_edit.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/widgets/app_button.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';

class PermisosEditWidget extends StatelessWidget {
  const PermisosEditWidget({
    super.key,
    this.detalle,
    this.edit = false,
  });

  final MaestroDetalle? detalle;
  final bool ? edit;

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
                        edit??false ? 'Editar opción' : 'Nueva opción',
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
                  padding:const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                  child: Column(
                    children: [
                      (edit??false)?
                        Column(
                          children: [
                            CustomTextField(
                                label: 'Opción',
                                isRequired: true,
                                controller: ctr.valorController,
                            ),
                            CustomTextField(
                                label: 'Código',
                                isRequired: true,
                                controller: ctr.valorController,
                            ),
                            const AppDropdownField(
                              dropdownKey: 'maestro_2',
                              isRequired: true,
                              label: 'Estado',
                            ),
                          ],
                        )
                        :
                       Column(
                         children: [                          
                           const AppDropdownField(
                             dropdownKey: 'maestro_2',
                             isRequired: true,
                             label: 'Opcion padre',
                           ),
                            CustomTextField(
                               label: 'Opción',
                               isRequired: true,
                               controller: ctr.valorController,
                           ),
                            CustomTextField(
                               label: 'Código',
                               isRequired: true,
                               controller: ctr.valorController,
                           ),
                           const AppDropdownField(
                             dropdownKey: 'maestro_2',
                             isRequired: true,
                             label: 'Estado',
                           ),
                         ],
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
                      onPressed: isEdit ? ctr.updateDetalle : ctr.saveDetalle,
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
