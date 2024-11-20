import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/maestro/maestro_controller.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';


class FilterUsersWidget extends StatelessWidget {
  const FilterUsersWidget({super.key});

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
                children: [
                  Column(
                    children: <Widget>[
                      const SizedBox(width: 20),
                      SizedBox(
                        width: Get.size.width*0.20,
                        child: CustomTextField(
                          label: 'Usuario',
                          controller: ctr.valorController,
                        ),
                      ),
                      SizedBox(
                        width: Get.size.width*0.20,
                        child: Obx(
                          () {
                            if (ctr.maestros.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return AppDropdownField(
                              dropdownKey: 'maestro',
                              label: 'Rol',
                              paddingLeft: 0,
                              options: ctr.maestros,
                              key: const Key('maestro_dropdown_maestro'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [                      
                      SizedBox(
                        width: Get.size.width*0.20,
                        child: CustomTextField(
                          label: 'Nombres y apellidos',
                          controller: ctr.valorController,
                        ),
                      ),
                      SizedBox(
                        width: Get.size.width*0.20,
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
                ],
              ),
              const SizedBox(height: 10.0),
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
