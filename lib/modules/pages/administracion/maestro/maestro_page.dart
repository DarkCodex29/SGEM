import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/widgets/active_box.dart';
import 'package:sgem/shared/widgets/app_text_field.dart';
import 'package:sgem/shared/widgets/custom_table/custom_table.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';

class MaestroPage extends StatelessWidget {
  const MaestroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(MaestroController());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const FilterTile(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        'Nuevo elemento',
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
                              Text(NumberFormat('000').format(mdetalle.key)),
                              Text(mdetalle.maestro.nombre ?? 'N/A'),
                              Text(mdetalle.value),
                              Text(mdetalle.usuarioRegistro ?? 'N/A'),
                              Text(mdetalle.fechaRegistro?.formatExtended ?? 'N/A'),
                              if (mdetalle.activo == null)
                                const Text('N/A')
                              else
                                Center(
                                  child: ActiveBox(
                                    isActive: mdetalle.activo == 'S',
                                  ),
                                ),
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
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: Get.find<AdministracionController>().screenPop,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child:
                  const Text('Regresar', style: TextStyle(color: Colors.white)),
            ),
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
                    child: AppTextField(
                      label: 'Valor',
                      controller: ctr.valorController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: AppDropdownField(
                      label: 'Estado',
                      dropdownKey: 'estado_m',
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
