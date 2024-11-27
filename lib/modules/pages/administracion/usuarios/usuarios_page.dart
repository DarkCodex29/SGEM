import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/widget/button_roles_permisos_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/modules/pages/administracion/usuarios/widget/filter_users_widget.dart';
import 'package:sgem/shared/widgets/custom_table/custom_table.dart';

class UsuariosPage extends StatelessWidget {
  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrRoles = Get.put(RolPermisoController());
    final ctr = Get.put(MaestroController());

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10.0
      ),
      child: Column(
        children: [
          const FilterUsersWidget(),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      const Text(
                        'Usuarios',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      const Spacer(),
                      Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          const MaestroEditView().show();
                        },
                        icon: const Icon(
                          Icons.download,
                          size: 18,
                          color: AppTheme.backgroundBlue,
                        ),
                        label: const Text(
                          'Descargar excel',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.backgroundBlue,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
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
                    const SizedBox(width: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          const MaestroEditView().show();
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 18,
                          color: AppTheme.primaryBackground,
                        ),
                        label: const Text(
                          'Nuevo usuario',
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
                  ],
                ),

                const SizedBox(height: 20),
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
                            Text("NumberFormat('000').format(mdetalle.key)"),
                            Text("mdetalle.maestro.nombre ?? 'N/A'"),
                            Text("mdetalle.value"),
                            Text("mdetalle.usuarioRegistro ?? 'N/A'"),
                            Text("mdetalle.fechaRegistro?.toString() ?? 'N/A'"),
                            Text("mdetalle.activo ?? 'N/A'"),
                          ];
                        },
                        actions: (mdetalle) => [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed:
                                MaestroEditView(detalle: mdetalle).show,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ButtonRolesPermisos(
            labelButton: "Regresar",
            onTap: Get.find<AdministracionController>().screenPop
          ),
        ],
      ),

    );
  }
}
