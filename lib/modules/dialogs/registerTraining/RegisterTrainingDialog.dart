
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/dialogs/registerTraining/RegisterTrainingController.dart';
import 'package:sgem/modules/dialogs/registerTraining/custom.popup.newEntrenamiento.dart';
import 'package:sgem/modules/pages/personal.training/training/training.personal.controller.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/modules/registrar.training.dart';
import 'package:sgem/shared/utils/Extensions/widgetExtensions.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class RegisterTrainingDialog extends StatelessWidget {

  final Personal data;
  RegisterTrainingDialog({Key? key, required this.data}) : super(key: key);

  final RegisterTrainingController controller = Get.put(RegisterTrainingController());
    double paddingVertical = 60;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.equipoDetalle.isEmpty) {
        return const CircularProgressIndicator();
      } else {
      return Scaffold( 
        appBar: AppBar(title: const Text ("Nuevo Entrenamiento")),
        body: 
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded( child: 
                    CustomDropdown(
                      hintText: "Equipo",
                      options: controller.equipoDetalle
                        .map((equipoDetalle) => (equipoDetalle.valor!)
                        ).toList(),
                      isSearchable: false,
                      isRequired: true,
                      onChanged: (value) {
                        //equipoSelected = value
                      },
                    )
                  ),
                  SizedBox(width: paddingVertical),
                  Expanded(child: 
                  customTextFieldDate("Fecha de inicio dd/mm/yyy", controller.fechaInicioEntrenamiento, true, false, context)
                  )
                ],
              ).padding(EdgeInsets.only(left: paddingVertical, right: paddingVertical)),

              Row(
                children: [
                  Expanded( child: 
                    CustomDropdown(
                      hintText: "Condicion",
                      options: const ["Experiencia", "Entrenamiento (Sin experiencia)"],
                      isSearchable: false,
                      isRequired: true,
                      //selectedValue: "Activo",
                      onChanged: (value) {
                      },
                    )
                  ),
                  SizedBox(width: paddingVertical),
                  Expanded(child: 
                    customTextFieldDate("Fecha de termino dd/mm/yyy",controller.fechaTerminoEntrenamiento, true, false, context)
                  )
                ],
              ).padding(EdgeInsets.only(left: paddingVertical, right: paddingVertical)),
              adjuntarArchivoText().padding(const EdgeInsets.only(bottom: 10)),
              adjuntarDocumentoPDF(controller),
              customButtonsCancelAndAcept(
                () =>{
                  
                }, 
                () => controller.personalSearchController.registertraining(RegisterTraining(
                  inTipoActividad: 1, 
                  inPersona: data.inPersonalOrigen,
                  inEquipo: 0, 
                  inCondicion: 0, 
                  fechaInicio: controller.transformDate(controller.fechaInicioEntrenamiento.text),
                  fechaTermino: controller.transformDate(controller.fechaTerminoEntrenamiento.text),
                ),
                )
                )
            ],
          ).padding(const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30))
      ).size(400, null);
      }
    }
    );
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


  Widget customButtonsCancelAndAcept(VoidCallback onCancel, VoidCallback onSave) {
    return  
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ]
      );
    }
  }

  Widget adjuntarDocumentoPDF(RegisterTrainingController controller) {
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

Widget customTextFieldDate(String label, TextEditingController fechaIngresoMinaController, bool isEditing, bool isViewing, BuildContext context) {
  return Expanded(
    child: CustomTextField(
      label: label,
      controller: fechaIngresoMinaController,
      icon: Icons.calendar_today,
      isReadOnly: isViewing,
      isRequired: !isViewing,
      onIconPressed: () {
        if (!isViewing) {
          _selectDate(
              context, fechaIngresoMinaController);
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
      //controller.text = picked.toString();
    }
}
  