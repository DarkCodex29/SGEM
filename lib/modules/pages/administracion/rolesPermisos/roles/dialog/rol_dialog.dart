import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api_rol_permiso.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/models/models.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';
import 'package:sgem/shared/widgets/app_button.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/active_dropdown_field.dart';

part 'rol_controller.dart';

class RolDialog extends StatelessWidget {
  const RolDialog({
    super.key,
    this.rol,
  });

  final Rol? rol;

  Future<bool?> show() async => Get.dialog<bool>(this);

  @override
  Widget build(BuildContext context) {
    final isEdit = rol != null;

    return GetBuilder<RolController>(
        init: RolController(rol: rol),
        builder: (ctr) {
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
                    maxWidth:
                        constraints.maxWidth > 500 ? 500 : constraints.maxWidth,
                    maxHeight: constraints.maxHeight > 800
                        ? 800
                        : constraints.maxHeight,
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
                              isEdit ? 'Editar rol' : 'Nuevo rol',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 8),
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Rol',
                              isRequired: true,
                              controller: ctr.name,
                            ),
                            const SizedBox(height: 12),
                            ActiveDropdownField(
                              value: rol?.actived,
                              onChanged: (value) => ctr.active.value = value,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton.white(
                            onPressed: Get.back<void>,
                            text: 'Cerrar',
                          ),
                          AppButton.blue(
                            onPressed: isEdit ? ctr.updateRol : ctr.saveRol,
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
        });
  }
}
