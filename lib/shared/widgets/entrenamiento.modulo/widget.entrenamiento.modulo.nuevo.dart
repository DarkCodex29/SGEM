import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/widgets/entrenamiento.modulo/widget.entrenamiento.modulo.nuevo.controller.dart';

import '../custom.textfield.dart';

class EntrenamientoModuloNuevo extends StatelessWidget {

  final EntrenamientoModuloNuevoController controller= EntrenamientoModuloNuevoController();
  final VoidCallback onCancel;

  EntrenamientoModuloNuevo({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          width: 714,
          height: 365,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(0, 1))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF051367),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Text(
                          'Nuevo Modulo', //$entityType
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onCancel,
                        child: const Icon(Icons.close,
                            size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Responsable",
                            controller: ,
                            //controller: controller.dniController,
                            // icon: Obx(() {
                            //   return controller.isLoadingDni.value
                            //       ? const CircularProgressIndicator()
                            //       : const Icon(Icons.search);
                            // }),
                            // isReadOnly: isEditing || isViewing,
                            // onIconPressed: () {
                            //   if (!controller.isLoadingDni.value &&
                            //       !isEditing &&
                            //       !isViewing) {
                            //     _searchPersonalByDNI();
                            //   }
                            // },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Column(
                      children: [
                        CustomTextField(
                          label: 'Fecha de inicio:',
                          controller:
                              controller.fechaInicioController, //cambiar controller
                          icon: const Icon(Icons.calendar_month),
                          onIconPressed: () {
                            _selectDate(context,
                                controller.fechaInicioController); //cambiar controller
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomTextField(
                          label: 'Fecha de termino:',
                          controller:
                              controller.fechaTerminoController, //cambiar controller
                          icon: const Icon(Icons.calendar_month),
                          onIconPressed: () {
                            _selectDate(context,
                                controller.fechaTerminoController); //cambiar controller
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
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
}
