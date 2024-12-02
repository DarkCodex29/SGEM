import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/maestro_controller.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos_controller.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';
import 'package:sgem/shared/widgets/dropDown/simple_app_dropdown.dart';

class RolesPorPermisoTabWidget extends StatelessWidget {
  const RolesPorPermisoTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrPermissions = Get.find<RolPermisoController>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: Get.size.height * 0.0),
          SizedBox(
            width: Get.size.width * 0.3,
            child: SimpleAppDropdown(
              options:
                  ctrPermissions.roles.map((e) => (e.key, e.name)).toList(),
              label: 'Rol',
              onChanged: (value) {
                final rol = value == null
                    ? null
                    : ctrPermissions.roles.firstWhere((e) => e.key == value);
                ctrPermissions.changeRolFiltro(rol);
              },
              isRequired: true,
              // dropdownKey: 'maestro_2',
            ),
          ),
          Expanded(
            child: Obx(() {
              final rolPermiso = ctrPermissions.permisosFiltrados;

              if (ctrPermissions.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: rolPermiso.length,
                      itemBuilder: (context, index) {
                        final (permiso, active) = rolPermiso[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: active,
                                onChanged: (value) {
                                  ctrPermissions.permisosFiltrados[index] =
                                      (permiso, value!);
                                },
                                checkColor: AppTheme.accent1,
                              ),
                              const SizedBox(width: 20.0),
                              Text(
                                permiso.name,
                                style: const TextStyle(
                                  color: AppTheme.primaryText,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (rolPermiso.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: ctrPermissions.saveRolPermisos,
                      icon: const Icon(
                        Icons.save,
                        size: 18,
                        color: AppTheme.primaryBackground,
                      ),
                      label: const Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryBackground,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
