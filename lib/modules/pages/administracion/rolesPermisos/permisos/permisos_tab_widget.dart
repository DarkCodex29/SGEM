import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/shared/models/models.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/widgets/active_box.dart';
import 'package:sgem/shared/widgets/custom_table/custom_table.dart';
import 'package:sgem/shared/widgets/table/data.table.dart';

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
              onPressed: ctr.onPermisoEdit,
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
            child: PermisoDataTable(permisos: ctr.permisos),
          ),
        ],
      ),
    );
  }
}

class PermisoDataTable extends StatelessWidget {
  const PermisoDataTable({
    super.key,
    required this.permisos,
  });

  final RxList<Permiso> permisos;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DataTable2(
        columns: const [
          'Opción',
          'Código',
          'Estado',
          'Usuario registro',
          'Fecha registro',
          'Acciones',
        ].map((e) => DataColumn2(label: Text(e))).toList(),
        dataRowColor: MaterialStateProperty.all(Colors.white),
        headingTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        headingRowDecoration: BoxDecoration(
          color: AppTheme.accent1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        dataRowHeight: 60,
        rows: permisos
            .map(
              (permiso) => DataRow(
                cells: [
                  // DataCell(Text(permiso.key.format)),
                  DataCell(Text(permiso.name)),
                  DataCell(Text(permiso.code)),
                  DataCell(ActiveBox(isActive: permiso.actived)),
                  DataCell(Text(permiso.userRegister)),
                  DataCell(Text(permiso.dateRegister.formatExtended)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Get.find<RolPermisoController>()
                          .onPermisoEdit(permiso),
                    ),
                  )
                ],
              ),
            )
            .toList(),
      );
    });
  }
}
