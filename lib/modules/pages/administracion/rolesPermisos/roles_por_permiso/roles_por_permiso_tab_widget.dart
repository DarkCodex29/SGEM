import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/maestro_controller.dart';
import 'package:sgem/modules/pages/administracion/rolesPermisos/roles_permisos_controller.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';

class RolesPorPermisoTabWidget extends StatelessWidget {
  const RolesPorPermisoTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<MaestroController>();
    final ctrPermissions = Get.find<RolesPermisosController>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
        SizedBox(height: Get.size.height*0.0),
       // const AppDropdownField(
       //   dropdownKey: 'maestro_2',
       //   isRequired: true,
       //   label: 'Rol',
       // ),
         Expanded(
          child: ListView.builder(
            itemCount: ctrPermissions.listEstaticForPermission.length ,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 15.0
                ),
                child: Row(
                  children: [
                   Checkbox(
                    value: false, 
                    onChanged: (value){
                
                    },
                    checkColor: AppTheme.accent1,
                   ),
                   const SizedBox(width: 20.0),
                   Text(
                    ctrPermissions.listEstaticForPermission[index].name, 
                    style: const TextStyle(
                      color: AppTheme.primaryText
                     )
                    )
                  ],
                ),
              );
            }
          ) 
         )
        ],
      ),
    );
  }
}