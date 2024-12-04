import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../shared/modules/cronograma.detail.dart';
import '../../../../shared/widgets/custom_table/custom_table.dart';
import '../administracion_controller.dart';
import 'cronograma_fechas_controller.dart';
import '../../../../config/theme/app_theme.dart';

class CronogramaFechasPage extends StatelessWidget {
  const CronogramaFechasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(CronogramaFechasController());

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterSection(),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      if (ctr.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (ctr.result.isEmpty) {
                        return const Center(
                          child: Text(
                            'No se encontraron resultados',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          // Botones de Carga y Descarga
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Acción para cargar cronograma
                                  print("Carga de cronograma");
                                },
                                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                                label: const Text(
                                  'Carga de cronograma',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: ctr.downloadExcel, // Llama al controlador
                                icon: const Icon(Icons.cloud_download, color: Colors.white),
                                label: const Text(
                                  'Descarga de cronograma',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.alternateColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Tabla de datos
                          Expanded(
                            child: CustomTable(
                              headers: const [
                                'Año',
                                'Guardia',
                                'Fecha inicio',
                                'Fecha fin',
                                'Usuario registro',
                                'Fecha registro',
                              ],
                              data: ctr.result,
                              builder: (detalle) {
                                return [
                                  Text(detalle.anio.toString()),
                                  Text(detalle.guardia),
                                  Text(DateFormat('dd/MM/yyyy').format(detalle.fechaInicio)),
                                  Text(DateFormat('dd/MM/yyyy').format(detalle.fechaFin)),
                                  Text(detalle.usuarioRegistro),
                                  Text(DateFormat('dd/MM/yyyy HH:mm:ss')
                                      .format(detalle.fechaRegistro)),
                                ];
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: Get.find<AdministracionController>().screenPop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Regresar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CronogramaFechasController>();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Año',
                      border: OutlineInputBorder(),
                    ),
                    items: [2023, 2024, 2025]
                        .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // Lógica para manejar el cambio
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Guardia',
                      border: OutlineInputBorder(),
                    ),
                    items: ['A', 'B', 'C']
                        .map((guard) => DropdownMenuItem(
                              value: guard,
                              child: Text(guard),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // Lógica para manejar el cambio
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Rango de fechas de inicio',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      // Mostrar selector de fecha
                    },
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: ctr.clearFilter,
                  icon: const Icon(Icons.cleaning_services, color: Colors.black),
                  label: const Text('Limpiar', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: ctr.search,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text('Buscar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
