import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.controller.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class FormMonitoringWidget extends StatelessWidget {
  const FormMonitoringWidget(
      {super.key,
      required this.isSmallScreen,
      required this.monitoringSearchController,
      required this.createMonitoringController,
      required this.isEditing});
  final bool isSmallScreen;
  final MonitoringSearchController monitoringSearchController;
  final CreateMonitoringController createMonitoringController;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                if (isSmallScreen)
                  Column(
                    children: [
                      _buildDropdownEstadoEntrenamiento(),
                      const SizedBox(height: 10),
                      _buildDropdownEquipo(),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Horas",
                        controller: TextEditingController(text: ""),
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownEntrenadorResponsable(),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Fecha real de monitoreo",
                        isReadOnly: true,
                        controller: TextEditingController(text: ""),
                        icon: const Icon(Icons.calendar_month),
                        onIconPressed: () {
                          _chooseDate(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Fecha Apróximada de monitoreo",
                        isReadOnly: true,
                        controller: TextEditingController(text: ""),
                        icon: const Icon(Icons.calendar_month),
                        onIconPressed: () {
                          _chooseDate(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownCondition(),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Comentarios",
                        controller: TextEditingController(text: ""),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownEstadoEntrenamiento(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdownEquipo(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Horas",
                              controller: TextEditingController(text: ""),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownEntrenadorResponsable(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Fecha real de monitoreo",
                              isReadOnly: true,
                              controller: createMonitoringController
                                  .fechaRealMonitoreoController,
                              icon: const Icon(Icons.calendar_month),
                              onIconPressed: () async {
                                final date = await _chooseDate(context);
                                createMonitoringController
                                    .fechaRealMonitoreoController
                                    .text = date.toString();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Fecha Apróximada de monitoreo",
                              isReadOnly: true,
                              controller: createMonitoringController
                                  .fechaProximoMonitoreoController,
                              icon: const Icon(Icons.calendar_month),
                              onIconPressed: () async {
                                final date = await _chooseDate(context);
                                createMonitoringController
                                    .fechaProximoMonitoreoController
                                    .text = date.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownCondition(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Comentarios",
                              controller: TextEditingController(text: ""),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: RichText(
            text: const TextSpan(
              text: "Adjuntar Archivos: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: "Archivo adjunto peso max:4MB",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.backgroundBlue,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Monitoreo de equipos pesados:"),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "",
                      isReadOnly: true,
                      controller: TextEditingController(text: ""),
                      icon: const Icon(Icons.attach_file),
                      onIconPressed: () {},
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Text("Monitoreo de equipos pesados:"),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 250,
                      child: CustomTextField(
                        label: "",
                        isReadOnly: true,
                        controller: TextEditingController(text: ""),
                        icon: const Icon(Icons.attach_file),
                        onIconPressed: () {},
                      ),
                    ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Otros:"),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "",
                      isReadOnly: true,
                      controller: TextEditingController(text: ""),
                      icon: const Icon(Icons.attach_file),
                      onIconPressed: () {},
                    ),
                  ],
                )
              : Row(
                  children: [
                    const SizedBox(width: 200, child: Text("Otros:")),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 250,
                      child: CustomTextField(
                        label: "",
                        isReadOnly: true,
                        controller: TextEditingController(text: ""),
                        icon: const Icon(Icons.attach_file),
                        onIconPressed: () {},
                      ),
                    ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
          child: _buildButtons(context),
        )
      ],
    );
  }

  Widget _buildDropdownEstadoEntrenamiento() {
    return Obx(() {
      if (monitoringSearchController.estadoEntrenamientoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      return CustomDropdown(
        hintText: 'Selecciona Estado de Entrenamiento',
        options: monitoringSearchController.estadoEntrenamientoOpciones
            .map((option) => option.valor ?? "")
            .toList(),
        selectedValue:
            monitoringSearchController.selectedEstadoEntrenamientoKey.value !=
                    null
                ? monitoringSearchController.estadoEntrenamientoOpciones
                    .firstWhere((option) =>
                        option.key ==
                        monitoringSearchController
                            .selectedEstadoEntrenamientoKey.value)
                    .valor
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption =
              monitoringSearchController.estadoEntrenamientoOpciones.firstWhere(
            (option) => option.valor == value,
          );
          monitoringSearchController.selectedEstadoEntrenamientoKey.value =
              selectedOption.key;
          createMonitoringController.selectedEstadoEntrenamientoKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownCondition() {
    return Obx(() {
      if (monitoringSearchController.condicionOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options =
          monitoringSearchController.condicionOpciones;
      return CustomDropdown(
        hintText: 'Selecciona condicion',
        options: options.map((option) => option.valor!).toList(),
        selectedValue:
            monitoringSearchController.selectedCondicionKey.value != null
                ? options
                    .firstWhere((option) =>
                        option.key ==
                        monitoringSearchController.selectedCondicionKey.value)
                    .valor
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          monitoringSearchController.selectedCondicionKey.value =
              selectedOption.key;
          createMonitoringController.selectedCondicionKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEquipo() {
    return Obx(() {
      if (monitoringSearchController.equipoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options = monitoringSearchController.equipoOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Equipo',
        options: options.map((option) => option.valor!).toList(),
        selectedValue:
            monitoringSearchController.selectedEquipoKey.value != null
                ? options
                    .firstWhere((option) =>
                        option.key ==
                        monitoringSearchController.selectedEquipoKey.value)
                    .valor
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          monitoringSearchController.selectedEquipoKey.value =
              selectedOption.key;
          createMonitoringController.selectedEquipoKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEntrenadorResponsable() {
    return Obx(() {
      if (monitoringSearchController.equipoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<Personal> options = monitoringSearchController.entrenadores;
      return CustomDropdown(
        hintText: 'Selecciona Entrenador',
        options: options.map((option) => option.nombreCompleto).toList(),
        selectedValue:
            monitoringSearchController.selectedEntrenadorKey.value != null
                ? options
                    .firstWhere((option) =>
                        option.inPersonalOrigen ==
                        monitoringSearchController.selectedEntrenadorKey.value)
                    .nombreCompleto
                    .toString()
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.nombreCompleto == value,
          );
          monitoringSearchController.selectedEntrenadorKey.value =
              selectedOption.inPersonalOrigen;
          createMonitoringController.selectedEntrenadorKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Future<DateTime?> _chooseDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    var initialDate = now;

    initialDate = initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now;

    final result = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorSchemeSeed: AppTheme.backgroundBlue,
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2025));

    if (result == null) {
      return null;
    }
    return result;
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            monitoringSearchController.screen.value =
                MonitoringSearchScreen.none;
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: createMonitoringController.isSaving.value
              ? null
              : () async {
                  // bool success = false;
                  // String accion = isEditing ? 'actualizar' : 'registrar';

                  // success = await controller.gestionarPersona(
                  //   accion: accion,
                  //   context: context,
                  // );
                  // if (success) {
                  //   onCancel();
                  // }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: Obx(() {
            return createMonitoringController.isSaving.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text("Guardar", style: TextStyle(color: Colors.white));
          }),
        ),
      ],
    );
  }
}
