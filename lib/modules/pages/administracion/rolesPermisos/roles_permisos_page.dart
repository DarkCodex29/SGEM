import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/permisos/permisos_tab_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_por_permiso/roles_por_permiso_tab_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/roles_tab_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles/widget/button_roles_permisos_widget.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';

class RolesPermisosPage extends StatelessWidget {
  const RolesPermisosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(RolesPermisosController());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TabBar(
              physics: const NeverScrollableScrollPhysics(),
              controller: ctr.tabControllerForRolesPermisos,
              indicatorColor: AppTheme.accent1,
              indicatorWeight: 3.0,
              labelColor: Colors.black,
              tabs: const [
                SizedBox(
                  width: 200.0,
                  child: Tab(
                    text: "Roles"
                    ),
                ),
                SizedBox(
                  width: 200.0,
                  child: Tab(
                    text: "Permisos"
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: Tab(
                    text: "Roles por permiso"
                  ),
                ),
              ],
              onTap: (index) async{
              },
            ),
            Expanded(
            child: TabBarView(
              controller: ctr.tabControllerForRolesPermisos, 
              children: const [
                 RolesTabWidget(),
                 PermisosTabWidget(),
                 RolesPorPermisoTabWidget()
            ]),
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

class FilterTile extends StatelessWidget {
  const FilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<MaestroController>();
    return ExpansionTile(
      title: const Text('Filtros'),
      initiallyExpanded: true,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Obx(
                      () {
                        if (ctr.maestros.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return AppDropdownField(
                          dropdownKey: 'maestro',
                          label: 'Maestro',
                          options: ctr.maestros,
                          key: const Key('maestro_dropdown_maestro'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      label: 'Valor',
                      controller: ctr.valorController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppDropdownField(
                      label: 'Estado',
                      dropdownKey: 'estado',
                      options: [
                        OptionValue(key: 1, nombre: 'Activo'),
                        OptionValue(key: 0, nombre: 'Inactivo'),
                      ],
                      // noDataHintText: 'No se encontraron estados',
                      // controller: ctr.dropdownController,
                      // hintText: 'Estado',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: ctr.clearFilter,
                    icon: const Icon(
                      Icons.cleaning_services,
                      size: 18,
                      color: AppTheme.primaryText,
                    ),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 49,
                        vertical: 18,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppTheme.alternateColor),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: ctr.search,
                    icon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Buscar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 49,
                        vertical: 18,
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
