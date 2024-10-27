import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/modules/pages/monitoring/view/create.monitoring.dart';
import 'package:sgem/modules/pages/monitoring/widget/detail.table.monitoring.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/custom.textfield.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

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
          case MonitoringSearchScreen.editMonitoring:
            return Container();
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
              _buildFormSection(controller, isSmallScreen),
              const SizedBox(height: 20),
              DetailTableMonitoring(
                  controller: controller, isSmallScreen: isSmallScreen)
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormSection(
      MonitoringSearchController controller, bool isSmallScreen) {
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
                      label: "Apellidos Paterno",
                      controller: controller.apellidosPaternoController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Apellidos Materno",
                      controller: controller.apellidosMaternoController,
                    ),
                    const SizedBox(width: 10),
                    _buildDropdownGuardia(controller),
                    const SizedBox(width: 10),
                    _buildDropdownEstadoEntrenamiento(controller),
                    const SizedBox(width: 10),
                    _buildDropdownEquipo(controller),
                    const SizedBox(width: 10),
                    _buildDropdownEntrenadorResponsable(controller),
                    const SizedBox(width: 10),
                    _buildDropdownCondicionMonitoreo(controller)
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
                              label: "Appellido Paterno",
                              controller: controller.apellidosPaternoController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Apellidos Materno",
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
                          Expanded(child: _buildDropdownEquipo(controller)),
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
                      onPressed: () {},
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

  Widget _buildDropdownGuardia(MonitoringSearchController controller) {
    // return Obx(() {
    List<String> options = ["Prueba"];
    String? selectDp;
    return CustomDropdown(
      hintText: 'Selecciona Guardia',
      options: options.map((option) => option).toList(),
      selectedValue: selectDp,
      isSearchable: false,
      isRequired: false,
      onChanged: (value) {},
    );
    // });
  }

  Widget _buildDropdownEstadoEntrenamiento(
      MonitoringSearchController controller) {
    // return Obx(() {
    List<String> options = ["Prueba"];
    String? selectDp;
    return CustomDropdown(
      hintText: 'Selecciona Estado de Entrenamiento',
      options: options.map((option) => option).toList(),
      selectedValue: selectDp,
      isSearchable: false,
      isRequired: false,
      onChanged: (value) {},
    );
    // });
  }

  Widget _buildDropdownEquipo(MonitoringSearchController controller) {
    // return Obx(() {
    List<String> options = ["Prueba"];
    String? selectDp;
    return CustomDropdown(
      hintText: 'Selecciona Equipo',
      options: options.map((option) => option).toList(),
      selectedValue: selectDp,
      isSearchable: false,
      isRequired: false,
      onChanged: (value) {},
    );
    // });
  }

  Widget _buildDropdownEntrenadorResponsable(
      MonitoringSearchController controller) {
    // return Obx(() {
    List<String> options = ["Prueba"];
    String? selectDp;
    return CustomDropdown(
      hintText: 'Selecciona Entrenador responsable',
      options: options.map((option) => option).toList(),
      selectedValue: selectDp,
      isSearchable: false,
      isRequired: false,
      onChanged: (value) {},
    );
    // });
  }

  Widget _buildDropdownCondicionMonitoreo(
      MonitoringSearchController controller) {
    // return Obx(() {
    List<String> options = ["Prueba"];
    String? selectDp;
    return CustomDropdown(
      hintText: 'Selecciona Condición del monitoreo',
      options: options.map((option) => option).toList(),
      selectedValue: selectDp,
      isSearchable: false,
      isRequired: false,
      onChanged: (value) {},
    );
    // });
  }
}
