import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/dialogs/entrenamiento/entrenamiento.nuevo.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/modules/registrar.training.dart';
import 'package:sgem/shared/utils/Extensions/widgetExtensions.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class EntrenamientoNuevoModal extends StatelessWidget {
  final Personal data;
  final EntrenamientoNuevoController controller =
      Get.put(EntrenamientoNuevoController());
  final double paddingVertical = 20;
  final VoidCallback close;

  EntrenamientoNuevoModal({super.key, required this.data, required this.close});

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: CustomGenericDropdown<MaestroDetalle>(
              hintText: "Equipo",
              options: controller.equipoDetalle,
              selectedValue: controller.equipoSelectedBinding,
              isSearchable: false,
              isRequired: true,
            )),
            SizedBox(width: paddingVertical),
            Expanded(
              child: customTextFieldDate("Fecha de inicio dd/mm/yyy",
                  controller.fechaInicioEntrenamiento, true, false, context),
            )
          ],
        ).padding(
            EdgeInsets.only(left: paddingVertical, right: paddingVertical)),
        Row(
          children: [
            Expanded(
                child: CustomGenericDropdown<MaestroDetalle>(
              hintText: "Condicion",
              options: controller.condicionDetalleList,
              selectedValue: controller.condicionSelectedBinding,
              isSearchable: false,
              isRequired: true,
            )),
            SizedBox(width: paddingVertical),
            Expanded(
                child: customTextFieldDate("Fecha de termino dd/mm/yyy",
                    controller.fechaTerminoEntrenamiento, true, false, context))
          ],
        ).padding(
            EdgeInsets.only(left: paddingVertical, right: paddingVertical)),
        adjuntarArchivoText().padding(const EdgeInsets.only(bottom: 10)),
        adjuntarDocumentoPDF(controller),
        customButtonsCancelAndAcept(() => close(), () => registertraining())
      ],
    ).padding(const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
              appBar: AppBar(title: const Text("Nuevo Entrenamiento")),
              body: (controller.isLoading.value)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : content(context))
          .size(400, 800);
    });
  }

  void registertraining() {
    if (controller.equipoSelected.value != null &&
        controller.condicionSelected.value != null) {
      controller.registertraining(
          RegisterTraining(
            inTipoActividad: 1,
            inPersona: data.key,
            inEquipo: controller.equipoSelected.value!.key,
            inCondicion: controller.condicionSelected.value!.key,
            fechaInicio: controller
                .transformDate(controller.fechaInicioEntrenamiento.text),
            fechaTermino: controller
                .transformDate(controller.fechaTerminoEntrenamiento.text),
          ), (isSucces) {
        close();
            });
    }
  }

  Widget adjuntarArchivoText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.attach_file, color: Colors.grey),
        SizedBox(width: 10),
        Text("Adjuntar archivo:"),
        SizedBox(width: 10),
        Text(
          "(Archivo adjunto peso máx: 4MB)",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget customButtonsCancelAndAcept(
      VoidCallback onCancel, VoidCallback onSave) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
        onPressed: onCancel,
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
          backgroundColor: Colors.blue,
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
  return Obx(() {
    if (controller.documentoAdjuntoNombre.value.isNotEmpty) {
      return Row(
        children: [
          TextButton.icon(
            onPressed: () {
              controller.eliminarDocumento();
            },
            icon: const Icon(Icons.close, color: Colors.red),
            label: Text(
              controller.documentoAdjuntoNombre.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          TextButton.icon(
            onPressed: () {
              controller.adjuntarDocumento();
            },
            icon: const Icon(Icons.attach_file, color: Colors.blue),
            label: const Text("Adjuntar Documento",
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    }
  });
}

Widget customTextFieldDate(
    String label,
    TextEditingController fechaIngresoMinaController,
    bool isEditing,
    bool isViewing,
    BuildContext context) {
  return Expanded(
    child: CustomTextField(
      label: label,
      controller: fechaIngresoMinaController,
      icon: const Icon(Icons.calendar_today),
      isReadOnly: isViewing,
      isRequired: !isViewing,
      onIconPressed: () {
        if (!isViewing) {
          _selectDate(context, fechaIngresoMinaController);
        }
      },
    ),
  );
}

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    controller.text = DateFormat('yyyy-MM-dd').format(picked);
  }
}
