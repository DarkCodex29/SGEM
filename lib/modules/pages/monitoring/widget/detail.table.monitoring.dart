import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.controller.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.motivo.dart';
import 'package:sgem/shared/widgets/table/custom.table.text.dart';
import 'package:sgem/shared/widgets/table/data.table.dart';

class DetailTableMonitoring extends StatelessWidget {
  const DetailTableMonitoring(
      {super.key, required this.controller, required this.isSmallScreen});
  final MonitoringSearchController controller;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final CreateMonitoringController createMonitoringController =
        Get.put(CreateMonitoringController());
    return Obx(() {
      return Container(
        width: double.infinity,
        height: 550,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            actionsWidgets(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable2(
                  showBottomBorder: true,
                  columnSpacing: 20.0,
                  minWidth: 2190.0,
                  dataRowHeight: 52.0,
                  headingRowHeight: 44.0,
                  fixedColumnsColor: Colors.red,
                  columns: const [
                    DataColumn2(
                      fixedWidth: 140,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Código MCP",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Apellido Paterno",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Apellido Materno",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Nombres",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Guardia",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Equipo",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 220,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Entrenador Responsable",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 220,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Condición de monitorieo",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 170,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Fecha del Monitoreo",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 140,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Estado  del reguistro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    DataColumn2(
                      fixedWidth: 240,
                      size: ColumnSize.L,
                      label: CustomText(
                        title: "Acciones",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                  rows: List.generate(controller.monitoringAll.length, (index) {
                    return DataRow(
                      color: MaterialStateProperty.all(
                          index % 2 == 0 + 1 ? Colors.grey.shade100 : null),
                      cells: [
                        DataCell(CustomText(
                          title: controller.monitoringAll[index].codigoMcp,
                        )),
                        DataCell(CustomText(
                          title:
                              controller.monitoringAll[index].apellidoPaterno,
                        )),
                        DataCell(CustomText(
                          title:
                              controller.monitoringAll[index].apellidoMaterno,
                        )),
                        DataCell(CustomText(
                          title:
                              "${controller.monitoringAll[index].primerNombre} ${controller.monitoringAll[index].segundoNombre}",
                        )),
                        DataCell(CustomText(
                          title: controller.monitoringAll[index].guardia!.nombre
                              .toString(),
                        )),
                        DataCell(CustomText(
                          title: controller.monitoringAll[index].equipo!.nombre,
                        )),
                        DataCell(CustomText(
                          title: controller
                              .monitoringAll[index].entrenador!.nombre,
                        )),
                        DataCell(CustomText(
                          title:
                              controller.monitoringAll[index].condicion!.nombre,
                        )),
                        const DataCell(CustomText(
                          title: "",
                        )),
                        const DataCell(CustomText(
                          title: "",
                        )),
                        DataCell(Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 3, bottom: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: AppTheme.backgroundBlue,
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () async {
                                      onDelete(
                                        context,
                                        createMonitoringController,
                                        controller.monitoringAll[index].key!,
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                      ],
                    );
                  }),
                ),
              ),
            ),
            _buildSeccionResultadoTablaPaginado()
          ],
        ),
      );
    });
  }

  void onDelete(BuildContext contextapp,
      CreateMonitoringController createController, int key) async {
    await showDialog(
      context: contextapp,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: DeleteReasonWidget(
              entityType: 'módulo',
              onCancel: () {
                Navigator.pop(context);
              },
              onConfirm: (motivo) async {
                // motivoEliminacion = motivo;
                Navigator.pop(context);
                createController.modelMonitoring.motivoEliminado = motivo;
                createController.modelMonitoring.key = key;
                final state = await createController.deleteMonitoring(contextapp);
                if (state) {
                  controller.searchMonitoring();
                }
              },
            ),
          ),
        );
      },
    );
  }

  SizedBox actionsWidgets() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          if (!isSmallScreen)
            const Spacer(
              flex: 2,
            ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                controller.isExpanded.value = false;
              },
              icon: const Icon(
                Icons.download,
                size: 18,
                color: Colors.black,
              ),
              label: const Text(
                "Descargar",
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppTheme.alternateColor),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                controller.screen.value = MonitoringSearchScreen.newMonitoring;
              },
              icon: const Icon(
                Icons.add,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                "Nuevo monitoreo",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionResultadoTablaPaginado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text(
              'Mostrando ${controller.currentPage.value * controller.rowsPerPage.value - controller.rowsPerPage.value + 1} - '
              '${controller.currentPage.value * controller.rowsPerPage.value > controller.totalRecords.value ? controller.totalRecords.value : controller.currentPage.value * controller.rowsPerPage.value} '
              'de ${controller.totalRecords.value} registros',
              style: const TextStyle(fontSize: 14),
            )),
        Obx(
          () => Row(
            children: [
              const Text("Items por página: "),
              DropdownButton<int>(
                value: controller.rowsPerPage.value > 0 &&
                        controller.rowsPerPage.value <= 50
                    ? controller.rowsPerPage.value
                    : null,
                items: [10, 20, 50]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.rowsPerPage.value = value;
                    controller.currentPage.value = 1;
                    controller.searchMonitoring(
                        pageNumber: controller.currentPage.value,
                        pageSize: value);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.currentPage.value > 1
                    ? () {
                        controller.currentPage.value--;
                        controller.searchMonitoring(
                            pageNumber: controller.currentPage.value,
                            pageSize: controller.rowsPerPage.value);
                      }
                    : null,
              ),
              Text(
                  '${controller.currentPage.value} de ${controller.totalPages.value}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    controller.currentPage.value < controller.totalPages.value
                        ? () {
                            controller.currentPage.value++;
                            controller.searchMonitoring(
                                pageNumber: controller.currentPage.value,
                                pageSize: controller.rowsPerPage.value);
                          }
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
