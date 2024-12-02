import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/shared/models/models.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/widgets/active_box.dart';
import 'package:sgem/shared/widgets/table/data.table.dart';

class RoleDataTable extends StatelessWidget {
  const RoleDataTable({
    super.key,
    required this.roles,
  });

  final RxList<Rol> roles;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DataTable2(
        columns: const [
          // 'Código',
          'Nombre',
          'Usuario registro',
          'Fecha registro',
          'Estado',
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
        rows: roles
            .map(
              (rol) => DataRow(
                cells: [
                  // DataCell(Text(rol.key.format)),
                  DataCell(Text(rol.name)),
                  DataCell(Text(rol.userRegister)),
                  DataCell(Text(rol.dateRegister.formatExtended)),
                  DataCell(ActiveBox(isActive: rol.actived)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          Get.find<RolPermisoController>().onRolEdit(rol),
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
