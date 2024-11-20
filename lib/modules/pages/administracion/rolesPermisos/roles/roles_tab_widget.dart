import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/widget/roles_edit_widget.dart';
import 'package:sgem/shared/widgets/custom_table/custom_table.dart';

class RolesTabWidget extends StatelessWidget {
  const RolesTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(MaestroController());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
         SizedBox(height: Get.size.height*0.05),
         Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              const RolesEditWidget(edit: false).show();
            },
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
            child: Obx(
              () {
                debugPrint('Result: ${ctr.result.length}');
                final result = ctr.result;

                if (result.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron resultados'),
                  );
                }

                return CustomTable(
                  headers: const [
                    'Código',
                    'Maestro',
                    'Valor',
                    'Usuario registro',
                    'Fecha registro',
                    'Estado',
                  ],
                  data: result,
                  builder: (mdetalle) {
                    return [
                      Text(NumberFormat('000').format(mdetalle.key)),
                      Text(mdetalle.maestro.nombre ?? 'N/A'),
                      Text(mdetalle.value),
                      Text(mdetalle.usuarioRegistro ?? 'N/A'),
                      Text(mdetalle.fechaRegistro?.toString() ?? 'N/A'),
                      Text(mdetalle.activo ?? 'N/A'),
                    ];
                  },
                  actions: (mdetalle) => [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed:const RolesEditWidget(edit: true).show,
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