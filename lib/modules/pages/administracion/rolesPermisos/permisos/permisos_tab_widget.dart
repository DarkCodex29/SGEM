import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/permisos/widget/permisos_edit_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/widgets/custom_table/custom_table.dart';

class PermisosTabWidget extends StatelessWidget {
  const PermisosTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(RolPermisoController());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: Get.size.height * 0.0),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                const PermisosEditWidget(edit: false).show();
              },
              icon: const Icon(
                Icons.add,
                size: 18,
                color: AppTheme.primaryBackground,
              ),
              label: const Text(
                'Nuevo opcion',
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
            child: Obx(
              () {
                final result = ctr.permisos;

                if (result.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron resultados'),
                  );
                }

                return CustomTable(
                  headers: const [
                    'Opción',
                    'Código',
                    'Estado',
                    'Usuario registro',
                    'Fecha registro',
                  ],
                  data: result,
                  builder: (permiso) {
                    return [
                      Text(permiso.key.format),
                      Text(permiso.name),
                      Text(permiso.code),
                      Text(permiso.userRegister),
                      Text(permiso.dateRegister.format),
                    ];
                  },
                  actions: (mdetalle) => [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: const PermisosEditWidget(edit: true).show,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

