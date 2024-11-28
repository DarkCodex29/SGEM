import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import '../../entrenamiento.personal.controller.dart';
import 'entrenamiento.nuevo.controller.dart';

class EntrenamientoNuevoModal extends StatelessWidget {
  final Personal data;
  final EntrenamientoNuevoController controller =
      Get.put(EntrenamientoNuevoController());
  final double paddingVertical = 20;
  final VoidCallback close;
  final bool isEdit;
  final EntrenamientoModulo? entrenamiento;

  EntrenamientoNuevoModal({
    super.key,
    required this.data,
    required this.close,
    this.isEdit = false,
    this.entrenamiento,
  }) {
    controller.clearFields();
    if (entrenamiento != null) controller.completeFields(entrenamiento!);
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEquipoAndDateRow(),
          const SizedBox(height: 10),
          _buildConditionAndDateRow(),
          if (isEdit) ...[
            const SizedBox(height: 10),
            _buildStateAndObservationsRow(),
            const SizedBox(height: 10),
            _buildObservationsRow(),
            const SizedBox(height: 10),
            //adjuntarArchivoText(),
            adjuntarDocumentoPDF(controller),
          ],
          const SizedBox(height: 20),
          customButtonsCancelAndAcept(
              () => close(), () => registerTraining(context)),
        ],
      ),
    );
  }

  Widget _buildEquipoAndDateRow() {
    return Row(
      children: [
        Expanded(
          child: CustomGenericDropdown<MaestroDetalle>(
            label: "Equipo",
            options: controller.equipoDetalle,
            selectedValue: controller.equipoSelectedBinding,
            isSearchable: false,
            isRequired: true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CustomTextField(
            label: 'Fecha de inicio:',
            controller: controller.fechaInicioController,
            isRequired: true,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () async {
              controller.fechaInicio = await _selectDate(Get.context!);
              controller.fechaInicioController.text = controller.fechaInicio ==
                      null
                  ? ' '
                  : DateFormat('dd/MM/yyyy').format(controller.fechaInicio!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConditionAndDateRow() {
    return Row(
      children: [
        Expanded(
          child: CustomGenericDropdown<MaestroDetalle>(
            label: "Condición",
            options: controller.condicionDetalle,
            selectedValue: controller.condicionSelectedBinding,
            isSearchable: false,
            isRequired: true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CustomTextField(
            label: 'Fecha de termino:',
            controller: controller.fechaTerminoController,
            // isRequired: true,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () async {
              controller.fechaTermino = await _selectDate(Get.context!);
              controller.fechaTerminoController.text = controller
                  .fechaTerminoController.text = controller.fechaTermino ==
                      null
                  ? ' '
                  : DateFormat('dd/MM/yyyy').format(controller.fechaTermino!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStateAndObservationsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomGenericDropdown<MaestroDetalle>(
            label: "Estado Entrenamiento",
            options: controller.estadoDetalle,
            selectedValue: controller.estadoEntrenamientoSelectedBinding,
            isSearchable: false,
            isRequired: true,
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildObservationsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            maxLines: 2,
            label: "Observaciones",
            controller: controller.observacionesEntrenamiento,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            minWidth: 300,
            minHeight: 200,
            maxHeight: isEdit ? 600 : 350,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? "Editar Entrenamiento" : "Nuevo Entrenamiento",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              // Cuerpo del modal
              Expanded(
                child: (controller.isLoading.value)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: content(context),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void registerTraining(BuildContext context) {
    List<String> errores = [];

    final fechaInicio = DateFormat('dd/MM/yyyy')
        .tryParse(controller.fechaInicioController.text);
    if (fechaInicio == null) {
      errores.add('Por favor, selecciona la fecha de inicio.');
    }

    final fechaTermino = DateFormat('dd/MM/yyyy')
        .tryParse(controller.fechaTerminoController.text);
    if (fechaTermino != null && fechaInicio != null) {
      if (fechaTermino.isBefore(fechaInicio)) {
        errores.add(
            'La fecha de término no puede ser anterior a la fecha de inicio.');
      }
    }

    if (controller.condicionSelected.value == null) {
      errores.add('Por favor, selecciona la condición.');
    }

    if (controller.equipoSelected.value == null) {
      errores.add('Por favor, selecciona el equipo.');
    }

    if (errores.isNotEmpty) {
      MensajeValidacionWidget(errores: errores).show(context);
      return;
    }

    int? estadoEntrenamientoKey =
        isEdit && controller.estadoEntrenamientoSelected.value != null
            ? controller.estadoEntrenamientoSelected.value!.key
            : 0;

    String observaciones = controller.observacionesEntrenamiento.text.isNotEmpty
        ? controller.observacionesEntrenamiento.text
        : '';

    EntrenamientoModulo newTraining = EntrenamientoModulo(
      key: isEdit
          ? entrenamiento!.key
          : 0, // Usar la key existente si es edición
      inTipoActividad: 1,
      inCapacitacion: 0,
      inModulo: 0,
      modulo: OptionValue(key: 0, nombre: ''),
      tipoPersona: '',
      inPersona: data.key,
      inActividadEntrenamiento: 0,
      inCategoria: 0,
      inEquipo: controller.equipoSelected.value!.key,
      equipo:
          OptionValue(key: controller.equipoSelected.value!.key, nombre: ''),
      inEntrenador: 0,
      entrenador: OptionValue(key: 0, nombre: ''),
      inEmpresaCapacitadora: 0,
      inCondicion: controller.condicionSelected.value!.key,
      condicion:
          OptionValue(key: controller.condicionSelected.value!.key, nombre: ''),
      fechaInicio: fechaInicio,
      fechaTermino: fechaTermino,
      fechaExamen: null,
      fechaRealMonitoreo: null,
      fechaProximoMonitoreo: null,
      inNotaTeorica: 0,
      inNotaPractica: 0,
      inTotalHoras: 0,
      inHorasAcumuladas: 0,
      inHorasMinestar: 0,
      inEstado: estadoEntrenamientoKey,
      estadoEntrenamiento: OptionValue(key: estadoEntrenamientoKey, nombre: ''),
      comentarios: '',
      eliminado: '',
      motivoEliminado: '',
      observaciones: observaciones,
    );

    final EntrenamientoPersonalController trainingPersonalController =
        Get.put(EntrenamientoPersonalController());
    if (isEdit) {
      trainingPersonalController
          .actualizarEntrenamiento(newTraining)
          .then((isSuccess) {
        if (isSuccess) {
          trainingPersonalController.fetchTrainings(data.key!);
          close();
        }
      });
    } else {
      controller.registertraining(newTraining, (isSuccess) {
        if (isSuccess) {
          trainingPersonalController.fetchTrainings(data.key!);
          close();
        }
      });
    }
  }

/*
  Widget adjuntarArchivoText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.attach_file, color: Colors.grey),
        SizedBox(width: 10),
        Text("Adjuntar archivo:"),
        SizedBox(width: 10),
        Text(
          "(Archivo adjunto peso máx: 8MB)",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
*/
  Widget customButtonsCancelAndAcept(
      VoidCallback onCancel, VoidCallback onSave) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
        onPressed: () {
          onCancel();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Cerrar',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      const SizedBox(width: 16),
      ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Guardar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }
}

Widget adjuntarDocumentoPDF(EntrenamientoNuevoController controller) {
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
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Obx(() {
        if (controller.isLoadingFiles.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.archivosAdjuntos.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.archivosAdjuntos.map((archivo) {
              return Container(
                width: 400,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: archivo['nuevo'] == true
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        archivo['nombre'],
                        style: TextStyle(
                          color: archivo['nuevo'] == true
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      children: [
                        if (archivo['nuevo'] == false)
                          IconButton(
                            icon: const Icon(Icons.download,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              controller.descargarArchivo(archivo);
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            archivo['nuevo'] == true
                                ? Icons.cancel
                                : Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            if (archivo['nuevo'] == true) {
                              // Remover archivo adjuntado recientemente
                              controller.removerArchivo(archivo['nombre']);
                            } else {
                              // Confirmar eliminación de archivo obtenido del servidor
                              showDialog(
                                context: Get.context!,
                                builder: (BuildContext context) {
                                  return ConfirmDeleteWidget(
                                    itemName: archivo['nombre'],
                                    entityType: 'archivo',
                                    onConfirm: () {
                                      controller.eliminarArchivo(archivo);
                                      Navigator.pop(context);
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "No hay archivos adjuntos.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          );
        }
      }),
      const SizedBox(height: 10),
      TextButton.icon(
        onPressed: () {
          controller.adjuntarDocumentos();
        },
        icon: const Icon(Icons.attach_file, color: Colors.blue),
        label: const Text(
          "Adjuntar Documento",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ],
  );
}

Future<DateTime?> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  return picked;
}
