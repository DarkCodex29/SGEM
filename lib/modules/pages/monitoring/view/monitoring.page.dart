import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/modules/pages/monitoring/view/create.monitoring.dart';
import 'package:sgem/modules/pages/monitoring/widget/detail.table.monitoring.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/custom.textfield.dart';

class MonitoringPage extends StatefulWidget {
  MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    final MonitoringSearchController controller =
        Get.put(MonitoringSearchController());
    return Scaffold(
      body: Obx(() {
        switch (controller.screen.value) {
          case MonitoringSearchScreen.none:
            return _buildSearchPage(controller, context);
          case MonitoringSearchScreen.newMonitoring:
            return CreateMonioringView(controller: controller);
          case MonitoringSearchScreen.viewMonitoring:
            return CreateMonioringView(controller: controller, isViewing: true);
          case MonitoringSearchScreen.editMonitoring:
            return CreateMonioringView(controller: controller, isEditing: true);
          case MonitoringSearchScreen.actualizacionMasiva:
            return Container();
          case MonitoringSearchScreen.trainingForm:
            return Container();
          case MonitoringSearchScreen.carnetMonitoring:
            return Container();
          case MonitoringSearchScreen.diplomaMonitoring:
            return Container();
          case MonitoringSearchScreen.certificadoMonitoring:
            return Container();
        }
      }),
    );
  }

  Widget _buildSearchPage(
      MonitoringSearchController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFormSection(controller, isSmallScreen, context),
              const SizedBox(height: 20),
              DetailTableMonitoring(
                  controller: controller, isSmallScreen: isSmallScreen)
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormSection(MonitoringSearchController controller,
      bool isSmallScreen, BuildContext context) {
    return Obx(() {
      return ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white),
        ),
        title: const Text(
          "Busqueda de Monitoreos",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.backgroundBlue),
        ),
        initiallyExpanded: controller.isExpanded.value,
        onExpansionChanged: (value) {
          controller.isExpanded.value = value;
        },
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                if (isSmallScreen)
                  Column(children: [
                    CustomTextField(
                      label: "Código MCP",
                      controller: controller.codigoMCPController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Nombres personal",
                      controller: controller.nombresController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Apellido Paterno",
                      controller: controller.apellidosPaternoController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Apellido Materno",
                      controller: controller.apellidosMaternoController,
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownGuardia(controller),
                    const SizedBox(height: 10),
                    _buildDropdownEstadoEntrenamiento(controller),
                    const SizedBox(height: 10),
                    _buildDropdownEquipo(controller),
                    const SizedBox(height: 10),
                    _buildDropdownEntrenadorResponsable(controller),
                    const SizedBox(height: 10),
                    _buildDropdownCondicionMonitoreo(controller),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Rango de fecha',
                      controller: controller.rangoFechaController,
                      icon: const Icon(Icons.calendar_month),
                      onIconPressed: () {
                        _selectDateRange(context, controller);
                      },
                    )
                  ])
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Código MCP",
                              controller: controller.codigoMCPController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Apellido Paterno",
                              controller: controller.apellidosPaternoController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Apellido Materno",
                              controller: controller.apellidosMaternoController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Nombres",
                              controller: controller.nombresController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: _buildDropdownGuardia(controller)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildDropdownEstadoEntrenamiento(
                                  controller)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildDropdownEquipo(controller)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildDropdownEntrenadorResponsable(
                                  controller)),
                          const SizedBox(width: 10),
                          Expanded(
                              child:
                                  _buildDropdownCondicionMonitoreo(controller)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                            label: 'Rango de fecha',
                            controller: controller.rangoFechaController,
                            icon: const Icon(Icons.calendar_month),
                            onIconPressed: () {
                              _selectDateRange(context, controller);
                            },
                          )),
                          const SizedBox(width: 10),
                          const Expanded(
                              child: SizedBox(
                            width: double.infinity,
                          )),
                          const SizedBox(width: 10),
                          const Expanded(
                              child: SizedBox(
                            width: double.infinity,
                          ))
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.clearFilter();
                        controller.searchMonitoring();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.cleaning_services,
                        size: 18,
                        color: AppTheme.primaryText,
                      ),
                      label: const Text(
                        "Limpiar",
                        style: TextStyle(
                            fontSize: 16, color: AppTheme.primaryText),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 49, vertical: 18),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: AppTheme.alternateColor),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        controller.isExpanded.value = false;
                        controller.searchMonitoring();
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Buscar",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 49, vertical: 18),
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
          )
        ],
      );
    });
  }

  Widget _buildDropdownEstadoEntrenamiento(
      MonitoringSearchController controller) {
    return Obx(() {
      if (controller.estadoEntrenamientoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      String? selectValue;
      if (controller.estadoEntrenamientoOpciones.isNotEmpty) {
        final selectOptionValue = controller.estadoEntrenamientoOpciones
            .where((option) =>
                option.key == controller.selectedEstadoEntrenamientoKey.value)
            .toList();
        if (selectOptionValue.isNotEmpty) {
          selectValue = selectOptionValue.first.valor;
        }
      }

      return CustomDropdown(
        hintText: 'Selecciona Estado de Entrenamiento',
        labelName: "Estado del Entrenamiento",
        options: controller.estadoEntrenamientoOpciones
            .map((option) => option.valor ?? "")
            .toList(),
        selectedValue: controller.selectedEstadoEntrenamientoKey.value != null
            ? selectValue
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption =
              controller.estadoEntrenamientoOpciones.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedEstadoEntrenamientoKey.value = selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownGuardia(MonitoringSearchController controller) {
    return Obx(() {
      if (controller.guardiaOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options = controller.guardiaOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Guardia',
        labelName: "Guardia",
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedGuardiaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedGuardiaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedGuardiaKey.value = selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEquipo(MonitoringSearchController controller) {
    return Obx(() {
      if (controller.equipoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options = controller.equipoOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Equipo',
        labelName: "Equipo",
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedEquipoKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedEquipoKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedEquipoKey.value = selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEntrenadorResponsable(
      MonitoringSearchController controller) {
    return Obx(() {
      if (controller.entrenadores.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<Personal> options = controller.entrenadores;
      return CustomDropdown(
        hintText: 'Selecciona Entrenador',
        labelName: "Entrenador",
        options: options.map((option) => option.nombreCompleto!).toList(),
        selectedValue: controller.selectedEntrenadorKey.value != null
            ? options
                .firstWhere((option) =>
                    option.inPersonalOrigen ==
                    controller.selectedEntrenadorKey.value)
                .nombreCompleto
                .toString()
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.nombreCompleto == value,
          );
          controller.selectedEntrenadorKey.value =
              selectedOption.inPersonalOrigen;
        },
      );
    });
  }

  Widget _buildDropdownCondicionMonitoreo(
      MonitoringSearchController controller) {
    return Obx(() {
      if (controller.condicionOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options = controller.condicionOpciones;
      return CustomDropdown(
        hintText: 'Selecciona condición',
        labelName: "Condición",
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedCondicionKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedCondicionKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedCondicionKey.value = selectedOption.key;
        },
      );
    });
  }

  final DateTime today = DateTime.now();

  Future<void> _selectDateRange(
      BuildContext context, MonitoringSearchController controller) async {
    DateTimeRange selectedDateRange = DateTimeRange(
      start: today.subtract(const Duration(days: 30)),
      end: today,
    );

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .5, // Ajusta el ancho
            height: MediaQuery.of(context).size.height * .7, // Ajusta el alto
            child: child,
          ),
        );
      },
    );
    if (picked != null && picked != selectedDateRange) {
      controller.rangoFechaController.text =
          '${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}';
      controller.fechaInicio = picked.start;
      controller.fechaTermino = picked.end;
    }
  }
}
