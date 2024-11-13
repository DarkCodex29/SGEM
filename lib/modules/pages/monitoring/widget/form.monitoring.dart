import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.controller.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/custom.text.fromfield.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.dart';

class FormMonitoringWidget extends StatefulWidget {
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
  State<FormMonitoringWidget> createState() => _FormMonitoringWidgetState();
}

class _FormMonitoringWidgetState extends State<FormMonitoringWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                  if (widget.isSmallScreen)
                    Column(
                      children: [
                        _buildDropdownEstadoEntrenamiento(),
                        const SizedBox(height: 10),
                        _buildDropdownEquipo(),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: "Horas",
                          controller:
                              widget.createMonitoringController.horasController,
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownEntrenadorResponsable(),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: "Fecha real de monitoreo",
                          isReadOnly: true,
                          controller: TextEditingController(
                            text: widget.createMonitoringController
                                        .fechaRealMonitoreoController ==
                                    null
                                ? ""
                                : DateFormat('dd/MM/yyyy').format(
                                    widget.createMonitoringController
                                        .fechaRealMonitoreoController!,
                                  ),
                          ),
                          icon: const Icon(Icons.calendar_month),
                          onIconPressed: () async {
                            final date = await _chooseDate(context);
                            widget.createMonitoringController
                                .fechaRealMonitoreoController = date;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: "Fecha Apróximada de monitoreo",
                          isReadOnly: true,
                          controller: TextEditingController(
                            text: widget.createMonitoringController
                                        .fechaProximoMonitoreoController ==
                                    null
                                ? ""
                                : DateFormat('dd/MM/yyyy').format(
                                    widget.createMonitoringController
                                        .fechaProximoMonitoreoController!,
                                  ),
                          ),
                          icon: const Icon(Icons.calendar_month),
                          onIconPressed: () async {
                            final date = await _chooseDate(context);
                            widget.createMonitoringController
                                .fechaProximoMonitoreoController = date;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownCondition(),
                        const SizedBox(height: 10),
                        CustomTextFormField(
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
                              child: CustomTextFormField(
                                label: "Horas",
                                controller: widget
                                    .createMonitoringController.horasController,
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
                              child: CustomTextFormField(
                                label: "Fecha real de monitoreo",
                                isReadOnly: true,
                                controller: TextEditingController(
                                  text: widget.createMonitoringController
                                              .fechaRealMonitoreoController ==
                                          null
                                      ? ""
                                      : DateFormat('dd/MM/yyyy').format(
                                          widget.createMonitoringController
                                              .fechaRealMonitoreoController!,
                                        ),
                                ),
                                icon: const Icon(Icons.calendar_month),
                                onIconPressed: () async {
                                  final date = await _chooseDate(context);
                                  widget.createMonitoringController
                                      .fechaRealMonitoreoController = date;
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextFormField(
                                label: "Fecha Apróximada de monitoreo",
                                isReadOnly: true,
                                controller: TextEditingController(
                                  text: widget.createMonitoringController
                                              .fechaProximoMonitoreoController ==
                                          null
                                      ? ""
                                      : DateFormat('dd/MM/yyyy').format(
                                          widget.createMonitoringController
                                              .fechaProximoMonitoreoController!,
                                        ),
                                ),
                                icon: const Icon(Icons.calendar_month),
                                onIconPressed: () async {
                                  final date = await _chooseDate(context);
                                  widget.createMonitoringController
                                      .fechaProximoMonitoreoController = date;
                                  setState(() {});
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
                              child: CustomTextFormField(
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
          if (widget.isEditing) _buildArchivoSection(),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
            child: _buildButtons(context),
          )
        ],
      ),
    );
  }

  Widget _buildArchivoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey),
            SizedBox(width: 10),
            Text("Archivos adjuntos:"),
            SizedBox(width: 10),
            Text(
              "(Archivos adjuntos peso máx: 8MB c/u)",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (widget.createMonitoringController.archivosAdjuntos.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("No hay archivos adjuntos."),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.createMonitoringController.archivosAdjuntos
                  .map((archivo) {
                return Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        widget.createMonitoringController
                            .eliminarArchivo(archivo['nombre']);
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: Text(
                        archivo['nombre'] ?? '',
                        style: TextStyle(
                          color: archivo['nuevo'] == true
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.blue),
                      onPressed: () {
                        widget.createMonitoringController
                            .descargarArchivo(archivo);
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }
        }),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {
            widget.createMonitoringController.adjuntarDocumentos();
          },
          icon: const Icon(Icons.attach_file, color: Colors.blue),
          label: const Text("Adjuntar Documentos",
              style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildDropdownEstadoEntrenamiento() {
    return Obx(() {
      if (widget
          .monitoringSearchController.estadoEntrenamientoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      if (widget.createMonitoringController.isLoandingDetail.value) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      String? selectValue;
      if (widget
          .monitoringSearchController.estadoEntrenamientoOpciones.isNotEmpty) {
        final selectOptionValue = widget
            .monitoringSearchController.estadoEntrenamientoOpciones
            .where((option) =>
                option.key ==
                widget.createMonitoringController.selectedEstadoEntrenamientoKey
                    .value)
            .toList();
        if (selectOptionValue.isNotEmpty) {
          selectValue = selectOptionValue.first.valor;
        }
      }

      return CustomDropdown(
        hintText: 'Selecciona Estado de Entrenamiento',
        options: widget.monitoringSearchController.estadoEntrenamientoOpciones
            .map((option) => option.valor ?? "")
            .toList(),
        selectedValue: widget.createMonitoringController
                    .selectedEstadoEntrenamientoKey.value !=
                null
            ? selectValue
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = widget
              .monitoringSearchController.estadoEntrenamientoOpciones
              .firstWhere(
            (option) => option.valor == value,
          );
          widget.createMonitoringController.selectedEstadoEntrenamientoKey
              .value = selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownCondition() {
    return Obx(() {
      if (widget.monitoringSearchController.condicionOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      if (widget.createMonitoringController.isLoandingDetail.value) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options =
          widget.monitoringSearchController.condicionOpciones;
      return CustomDropdown(
        hintText: 'Selecciona condicion',
        options: options.map((option) => option.valor!).toList(),
        selectedValue:
            widget.createMonitoringController.selectedCondicionKey.value != null
                ? options
                    .firstWhere((option) =>
                        option.key ==
                        widget.createMonitoringController.selectedCondicionKey
                            .value)
                    .valor
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          widget.createMonitoringController.selectedCondicionKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEquipo() {
    return Obx(() {
      if (widget.monitoringSearchController.equipoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      if (widget.createMonitoringController.isLoandingDetail.value) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<MaestroDetalle> options =
          widget.monitoringSearchController.equipoOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Equipo',
        options: options.map((option) => option.valor!).toList(),
        selectedValue:
            widget.createMonitoringController.selectedEquipoKey.value != null
                ? options
                    .firstWhere((option) =>
                        option.key ==
                        widget
                            .createMonitoringController.selectedEquipoKey.value)
                    .valor
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          widget.createMonitoringController.selectedEquipoKey.value =
              selectedOption.key;
        },
      );
    });
  }

  Widget _buildDropdownEntrenadorResponsable() {
    return Obx(() {
      if (widget.monitoringSearchController.equipoOpciones.isEmpty) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      if (widget.createMonitoringController.isLoandingDetail.value) {
        return const CupertinoActivityIndicator(
          radius: 10,
          color: Colors.grey,
        );
      }
      List<Personal> options = widget.monitoringSearchController.entrenadores;
      return CustomDropdown(
        hintText: 'Selecciona Entrenador',
        options: options.map((option) => option.nombreCompleto!).toList(),
        selectedValue:
            widget.createMonitoringController.selectedEntrenadorKey.value !=
                    null
                ? options
                    .firstWhere((option) =>
                        option.inPersonalOrigen ==
                        widget.createMonitoringController.selectedEntrenadorKey
                            .value)
                    .nombreCompleto
                    .toString()
                : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.nombreCompleto == value,
          );
          widget.createMonitoringController.selectedEntrenadorKey.value =
              selectedOption.inPersonalOrigen;
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
            widget.monitoringSearchController.screen.value =
                MonitoringSearchScreen.none;
            widget.createMonitoringController.clearModel();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: widget.createMonitoringController.isSaving.value
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    final state = await widget.createMonitoringController
                        .saveMonitoring(context);
                    if (state) {
                      if (widget.isEditing) {
                        widget.createMonitoringController.uploadArchive();
                      } else {
                        widget.monitoringSearchController.screen.value =
                            MonitoringSearchScreen.none;
                        // widget.monitoringSearchController.screen.value =
                        //     widget.monitoringSearchController.clearFilter();
                        // widget.createMonitoringController.clearModel();
                        widget.monitoringSearchController
                            .searchMonitoring(pageNumber: 1, pageSize: 10);
                      }
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: Obx(() {
            return widget.createMonitoringController.isSaving.value
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
