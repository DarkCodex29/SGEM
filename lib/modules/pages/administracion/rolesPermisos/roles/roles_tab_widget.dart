import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/roles.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos_controller.dart';

class RolesTabWidget extends StatelessWidget {
  const RolesTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(RolPermisoController());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: Get.size.height * 0.05),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: ctr.onRolEdit,
              icon: const Icon(
                Icons.add,
                size: 18,
                color: AppTheme.primaryBackground,
              ),
              label: const Text(
                'Nuevo rol',
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
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: RoleDataTable(roles: ctr.roles),
          ),
        ],
      ),
    );
  }
}
