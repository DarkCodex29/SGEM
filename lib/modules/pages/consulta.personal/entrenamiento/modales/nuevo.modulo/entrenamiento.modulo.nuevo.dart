import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/custom.text.fromfield.dart';
import '../../../../../../config/theme/app_theme.dart';
import '../../../../../../shared/widgets/custom.textfield.dart';
import '../../../../../../shared/widgets/dropDown/custom.dropdown.global.dart';
import 'entrenamiento.modulo.nuevo.controller.dart';

class EntrenamientoModuloNuevo extends StatelessWidget {
  final EntrenamientoModuloNuevoController controller =
      EntrenamientoModuloNuevoController();
  final VoidCallback onCancel;
  final EntrenamientoModulo? entrenamiento;
  final bool isEdit;
  final int? inEntrenamientoModulo;
  final int? inEntrenamiento;
  final int? inPersona;
  final bool isView;
  EntrenamientoModuloNuevo({
    super.key,
    required this.onCancel,
    this.entrenamiento,
    this.isEdit = false,
    this.inEntrenamientoModulo,
    this.inEntrenamiento,
    this.inPersona,
    this.isView = false,
  });

  @override
  Widget build(BuildContext context) {
    controller.isEdit = isEdit;
    controller.isView = isView;
    if (inEntrenamientoModulo != null) {
      controller.obtenerModuloPorId(inEntrenamiento!, inEntrenamientoModulo!);
    } else {
      controller.nuevoModulo(inEntrenamiento!);
    }

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            width: 800,
            height: isEdit == false ? 600 : 900,
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
                _buildModalTitulo(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrimeraFila(),
                      _buildSegundaFila(context),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildTerceraFila(context),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isEdit) _buildSeccionAdjuntos(),
                      _buildBotones(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalTitulo() {
    return Container(
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
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Obx(() {
                return controller.isLoadingModulo.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        controller.tituloModal.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
              }),
            ),
            InkWell(
              onTap: onCancel,
              child: const Icon(Icons.close, size: 24, color: Colors.white),
            ),
          ],
        ),
      ),
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

  Widget _buildPrimeraFila() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomDropdownGlobal(
            labelText: 'Entrenador',
            dropdownKey: 'entrenador',
            hintText: "Responsable",
            noDataHintText: 'No se encontraron entrenadores',
            controller: controller.dropdownController,
            //isReadOnly: isView,
          ),
        ),
        const SizedBox(width: 20),
        isEdit
            ? Expanded(
                flex: 1,
                child: CustomDropdownGlobal(
                  labelText: 'Estado de módulo',
                  dropdownKey: 'estadoModulo',
                  hintText: "Estado",
                  noDataHintText: 'No se encontraron estados de módulos',
                  controller: controller.dropdownController,
                  isReadOnly: isView,
                ),
              )
            : const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
      ],
    );
  }

  Widget _buildSegundaFila(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: 'Fecha de inicio:',
            controller: controller.fechaInicioController,
            isRequired: true,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () async {
              controller.fechaInicio = await _selectDate(context);
              controller.fechaInicioController.text =
                  DateFormat('dd/MM/yyyy').format(controller.fechaInicio!);
            },
            isReadOnly: isView,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: 'Fecha de termino:',
            controller: controller.fechaTerminoController,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () async {
              controller.fechaTermino = await _selectDate(context);
              controller.fechaTerminoController.text =
                  DateFormat('dd/MM/yyyy').format(controller.fechaTermino!);
            },
            isReadOnly: isView,
          ),
        ),
      ],
    );
  }

  Widget _buildTerceraFila(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: _buildNotaSeccion(context),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildHoraSeccion(context),
        ),
      ],
    );
  }

  Widget _buildNotaSeccion(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notas",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            CustomTextField(
              label: 'Teórico',
              controller: controller.notaTeoricaController,
              isReadOnly: isView,
            ),
            CustomTextField(
              label: 'Práctico',
              controller: controller.notaPracticaController,
              isReadOnly: isView,
            ),
            CustomTextField(
              label: 'Fecha de examen:',
              controller: controller.fechaExamenController,
              icon: const Icon(Icons.calendar_month),
              onIconPressed: () async {
                controller.fechaExamen = await _selectDate(context);
                controller.fechaExamenController.text =
                    DateFormat('dd/MM/yyyy').format(controller.fechaExamen!);
              },
              isReadOnly: isView,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoraSeccion(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Horas",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Obx(() {
              return CustomTextField(
                label: 'Total horas módulo',
                controller: controller.totalHorasModuloController.value,
                keyboardType: TextInputType.number,
                isReadOnly: true,
              );
            }),
            CustomTextField(
              label: 'Horas acumuladas',
              controller: controller.horasAcumuladasController,
              icon: const Icon(Icons.more_time),
              isReadOnly: isView,
            ),
            CustomTextField(
              label: 'Horas minestar',
              controller: controller.horasMinestarController,
              icon: const Icon(Icons.lock_clock_outlined),
              isReadOnly: isView,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionAdjuntos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              "Archivos adjuntos:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "(Archivos adjuntos peso máx: 8MB c/u)",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _buildAdjuntoRow(
            'Control de horas',
            controller.aaControlHorasController,
            () async {
              controller.cargarArchivoControlHoras();
            },
            () async {
              if (controller.aaControlHorasSeleccionado.value) {
                controller.aaControlHorasController.clear();
                controller.aaControlHorasSeleccionado.value = false;
              }
            },
            controller.aaControlHorasSeleccionado.value,
            () async {
              if (controller.aaControlHorasExiste.value) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return const MensajeValidacionWidget(
                      errores: [
                        "Ya existe un archivo subido para CONTROL DE HORAS. Debe eliminar el anterior para poder subir uno nuevo."
                      ],
                    );
                  },
                );
                return;
              }

              if (!controller.aaControlHorasSeleccionado.value) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return const MensajeValidacionWidget(
                      errores: [
                        "Debe seleccionar un archivo para poder subirlo."
                      ],
                    );
                  },
                );
                return;
              }
              controller.registrarArchivoControlHoras();
            },
            () async {
              if (controller.aaControlHorasExiste.value) {
                controller.eliminarArchivo(controller.aaControlHorasId.value);
              } else {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return const MensajeValidacionWidget(
                      errores: ["No hay archivo para eliminar."],
                    );
                  },
                );
              }
            },
            controller.aaControlHorasExiste.value),
        _buildAdjuntoRow(
          'Examen Teórico',
          controller.aaExamenTeoricoController,
          () async {
            controller.cargarArchivoExamenTeorico();
          },
          () async {
            if (controller.aaExamenTeoricoSeleccionado.value) {
              controller.aaExamenTeoricoController.clear();
              controller.aaExamenTeoricoSeleccionado.value = false;
            }
          },
          controller.aaExamenTeoricoSeleccionado.value,
          () async {
            if (controller.aaExamenTeoricoExiste.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Ya existe un archivo subido para EXAMEN TEORICO. Debe eliminar el anterior para poder subir uno nuevo."
                    ],
                  );
                },
              );
              return;
            }

            if (!controller.aaExamenTeoricoSeleccionado.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Debe seleccionar un archivo para poder subirlo."
                    ],
                  );
                },
              );
              return;
            }
            controller.registrarArchivoExamenTeorico();
          },
          () async {
            if (controller.aaExamenTeoricoExiste.value) {
              controller.eliminarArchivo(controller.aaExamenTeoricoId.value);
            } else {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: ["No hay archivo para eliminar."],
                  );
                },
              );
            }
          },
          controller.aaExamenTeoricoExiste.value,
        ),
        _buildAdjuntoRow(
          'Examen Práctico',
          controller.aaExamenPracticoController,
          () async {
            controller.cargarArchivoExamenPractico();
          },
          () {
            if (controller.aaExamenPracticoSeleccionado.value) {
              controller.aaExamenPracticoController.clear();
              controller.aaExamenPracticoSeleccionado.value = false;
            }
          },
          controller.aaExamenPracticoSeleccionado.value,
          () async {
            if (controller.aaExamenPracticoExiste.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Ya existe un archivo subido para EXAMEN PRACTICO. Debe eliminar el anterior para poder subir uno nuevo."
                    ],
                  );
                },
              );
              return;
            }

            if (!controller.aaExamenPracticoSeleccionado.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Debe seleccionar un archivo para poder subirlo."
                    ],
                  );
                },
              );
              return;
            }
            controller.registrarArchivoExamenPractico();
          },
          () async {
            if (controller.aaExamenPracticoExiste.value) {
              controller.eliminarArchivo(controller.aaExamenPracticoId.value);
            } else {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: ["No hay archivo para eliminar."],
                  );
                },
              );
            }
          },
          controller.aaExamenPracticoExiste.value,
        ),

        _buildAdjuntoRow(
          'Otros',
          controller.aaOtrosController,
          () async {
            controller.cargarArchivoOtros();
          },
          () async {
            if (controller.aaOtrosSeleccionado.value) {
              controller.aaOtrosController.clear();
              controller.aaOtrosSeleccionado.value = false;
            }
          },
          controller.aaOtrosSeleccionado.value,
          () async {
            if (controller.aaOtrosExiste.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Ya existe un archivo subido para OTROS. Debe eliminar el anterior para poder subir uno nuevo."
                    ],
                  );
                },
              );
              return;
            }

            if (!controller.aaOtrosSeleccionado.value) {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: [
                      "Debe seleccionar un archivo para poder subirlo."
                    ],
                  );
                },
              );
              return;
            }
            controller.registrarArchivoOtros();
          },
          () async {
            if (controller.aaOtrosExiste.value) {
              controller.eliminarArchivo(controller.aaOtrosId.value);
            } else {
              showDialog(
                context: Get.context!,
                builder: (context) {
                  return const MensajeValidacionWidget(
                    errores: ["No hay archivo para eliminar."],
                  );
                },
              );
            }
          },
          controller.aaOtrosExiste.value,
        ),
        // Obx((){
        //
        //   return Column(crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //
        //   ],
        //   );
        // }),
      ],
    );
  }

  Widget _buildAdjuntoRow(
    String titulo,
    TextEditingController controller,
    VoidCallback onPressed,
    VoidCallback onRemove,
    bool archivoSeleccionado,
    VoidCallback onUpload,
    VoidCallback onDelete,
bool archivoExiste,
  ) {
    return Row(
      children: [
        Text(titulo),
        const SizedBox(width: 10),
        IconButton(
            tooltip: 'Adjuntar archivo',
            onPressed: onPressed,
            icon: const Icon(Icons.attach_file, color: Colors.grey)),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: CustomTextFormField(
            label: 'Archivo',
            controller: controller,
            isReadOnly: true,
            isRequired: false,
            textStyle: archivoSeleccionado
                ? const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent)
                : const TextStyle(),
            //nombreArchivo,
            //style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        //if (archivoSeleccionado)
          IconButton(
            tooltip: 'Quitar archivo',
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onRemove,
          ),
        const SizedBox(width: 10),
        //if (archivoSeleccionado)
          IconButton(
            tooltip: 'Subir archivo',
            icon: const Icon(Icons.upload_rounded, color: Colors.blueAccent),
            onPressed: onUpload,
          ),
        const SizedBox(width: 10),
        /*
        Obx((){
          if(archivoExiste) {
            return IconButton(
              tooltip: 'Elimnar archivo',
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            );
          };
          return SizedBox(width: 10,);
        } ),
        */

        //if (archivoExiste)
          IconButton(
            tooltip: 'Elimnar archivo',
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildBotones(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              onCancel();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = false;
              var pendientes = controller.validarArchivosPorSubir();
              log('pendientes: ${pendientes}');
              if (pendientes) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return const MensajeValidacionWidget(
                      errores: [
                        "Hay archivos selecionados pendientes por subir. Confirmelos o eliminelos."
                      ],
                    );
                  },
                );
              } else {
                success = await controller.registrarModulo(context);
                if (success) {
                  onCancel();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: Obx(() {
              return controller.isSaving.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Guardar",
                      style: TextStyle(color: Colors.white));
            }),
          ),
        ],
      ),
    );
  }
}
