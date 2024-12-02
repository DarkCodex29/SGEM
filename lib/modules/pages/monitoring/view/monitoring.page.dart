import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/modules/pages/monitoring/view/create.monitoring.dart';
import 'package:sgem/modules/pages/monitoring/widget/detail.table.monitoring.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/app_dropdown_field.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.dart';
import 'package:sgem/shared/widgets/dropDown/simple_app_dropdown.dart';

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
            return CreateMonitoringView(controller: controller);
          case MonitoringSearchScreen.viewMonitoring:
            return CreateMonitoringView(controller: controller, isViewing: true);
          case MonitoringSearchScreen.editMonitoring:
            return CreateMonitoringView(controller: controller, isEditing: true);
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
    final guardDropdown = _Dropdown(
      options: controller.guardiaOpciones,
      value: controller.selectedGuardiaKey,
      label: "Guardia",
    );

    final estadoEntrenamientoDropdown = _Dropdown(
      options: controller.estadoEntrenamientoOpciones,
      value: controller.selectedEstadoEntrenamientoKey,
      label: "Estado de Entrenamiento",
    );

    final equipoDropdown = _Dropdown(
      options: controller.equipoOpciones,
      value: controller.selectedEquipoKey,
      label: "Equipo",
    );

    final entrenadorDropdown = _buildDropdownEntrenadorResponsable(controller);

    final condicionDropdown = _Dropdown(
      options: controller.condicionOpciones,
      value: controller.selectedCondicionKey,
      label: "Condición",
    );

    return Obx(() {
      return ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white),
        ),
        title: const Text(
          "Búsqueda de Monitoreos",
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
            child: Form(
              child: Column(
                children: [
                  if (isSmallScreen)
                    Column(
                      children: [
                        CustomTextField(
                          label: "Código MCP",
                          controller: controller.codigoMCPController,
                          validator: (value) {
                            if ((value?.length ?? 0) > 9) {
                              return 'Código MCP muy largo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Nombres personal",
                          controller: controller.nombresController,
                          validator: (value) {
                            if ((value?.length ?? 0) > 50) {
                              return 'Nombre muy largo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Apellido Paterno",
                          controller: controller.apellidosPaternoController,
                          validator: (value) {
                            if ((value?.length ?? 0) > 50) {
                              return 'Nombre muy largo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Apellido Materno",
                          controller: controller.apellidosMaternoController,
                        ),
                        const SizedBox(height: 10),
                        guardDropdown,
                        const SizedBox(height: 10),
                        estadoEntrenamientoDropdown,
                        const SizedBox(height: 10),
                        equipoDropdown,
                        const SizedBox(height: 10),
                        entrenadorDropdown,
                        const SizedBox(height: 10),
                        condicionDropdown,
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: 'Rango de fecha',
                          controller: controller.rangoFechaController,
                          icon: const Icon(Icons.calendar_month),
                          onIconPressed: () {
                            _selectDateRange(context, controller);
                          },
                        )
                      ],
                    )
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
                                controller:
                                    controller.apellidosPaternoController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                label: "Apellido Materno",
                                controller:
                                    controller.apellidosMaternoController,
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
                            Expanded(child: guardDropdown),
                            const SizedBox(width: 10),
                            Expanded(child: estadoEntrenamientoDropdown),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: equipoDropdown),
                            const SizedBox(width: 10),
                            Expanded(child: entrenadorDropdown),
                            const SizedBox(width: 10),
                            Expanded(child: condicionDropdown),
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
                            side: const BorderSide(
                                color: AppTheme.alternateColor),
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
            ),
          )
        ],
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
      return SimpleAppDropdown(
        hint: 'Selecciona Entrenador',
        label: 'Entrenador',
        hasTodos: true,
        options: options
            .map((option) => (option.key!, option.nombreCompleto!))
            .toList(),
        initialValue: controller.selectedEntrenadorKey.value,
        isRequired: false,
        onChanged: (value) {
          controller.selectedEntrenadorKey.value = value;
        },
      );
    });
  }

  Future<void> _selectDateRange(
      BuildContext context, MonitoringSearchController controller) async {
    final DateTime today = DateTime.now();
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

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.options,
    required this.value,
    required this.label,
  });

  final RxList<MaestroDetalle> options;
  final RxnInt value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (options.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }

      return SimpleAppDropdown(
        label: label,
        hint: 'Selecciona $label',
        options: options.map((option) => (option.key!, option.valor!)).toList(),
        initialValue: value.value,
        isRequired: false,
        hasTodos: true,
        onChanged: (value) {
          Logger('MonitoringPage').info('[$label] value: $value');
          this.value.value = value;
          Logger('MonitoringPage').info('[$label] value: ${this.value.value}');
        },
      );
    });
  }
}
