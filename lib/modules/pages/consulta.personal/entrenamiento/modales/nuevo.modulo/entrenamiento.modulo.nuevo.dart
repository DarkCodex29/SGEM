import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            height: (isEdit || isView) ? 900 : 600,
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
                      if (isEdit || isView) _buildSeccionAdjuntos(),
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
            isReadOnly: isView,
          ),
        ),
        const SizedBox(width: 20),
        isEdit || isView
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
            onIconPressed: isView
                ? null
                : () async {
                    controller.fechaInicio = await _selectDate(context);
                    controller.fechaInicioController.text =
                        DateFormat('dd/MM/yyyy')
                            .format(controller.fechaInicio!);
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
            onIconPressed: isView
                ? null
                : () async {
                    controller.fechaTermino = await _selectDate(context);
                    controller.fechaTerminoController.text =
                        DateFormat('dd/MM/yyyy')
                            .format(controller.fechaTermino!);
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
              onIconPressed: isView
                  ? null
                  : () async {
                      controller.fechaExamen = await _selectDate(context);
                      controller.fechaExamenController.text =
                          DateFormat('dd/MM/yyyy')
                              .format(controller.fechaExamen!);
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
            controller.aaControlHorasSeleccionado,
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
            controller.aaControlHorasExiste),
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
          controller.aaExamenTeoricoSeleccionado,
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
          controller.aaExamenTeoricoExiste,
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
          controller.aaExamenPracticoSeleccionado,
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
          controller.aaExamenPracticoExiste,
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
          controller.aaOtrosSeleccionado,
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
          controller.aaOtrosExiste,
        ),
      ],
    );
  }

  Widget _buildAdjuntoRow(
    String titulo,
    TextEditingController controller,
    VoidCallback onPressed,
    VoidCallback onRemove,
    RxBool archivoSeleccionado,
    VoidCallback onUpload,
    VoidCallback onDelete,
    RxBool archivoExiste,
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
          ),
        ),
        const SizedBox(width: 10),
        Obx(() {
          if (archivoSeleccionado.value) {
            return IconButton(
              tooltip: 'Quitar archivo',
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onRemove,
            );
          }
          return const SizedBox(
            width: 0,
          );
        }),
        const SizedBox(width: 10),
        Obx(() {
          if (!archivoExiste.value && archivoSeleccionado.value) {
            return IconButton(
              tooltip: 'Subir archivo',
              icon: const Icon(Icons.upload_rounded, color: Colors.blueAccent),
              onPressed: onUpload,
            );
          }
          ;
          return const SizedBox(
            width: 0,
          );
        }),
        Obx(() {
          if (archivoExiste.value && isEdit) {
            return IconButton(
              tooltip: 'Elimnar archivo',
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            );
          }
          ;
          return const SizedBox(
            width: 0,
          );
        }),
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
          isView
              ? SizedBox(
                  width: 0,
                )
              : ElevatedButton(
                  onPressed: () async {
                    final success = await _handleButtonPress();
                    if (success) {
                      onCancel();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                  ),
                  child: Obx(() {
                    return controller.isSaving.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Guardar",
                            style: TextStyle(color: Colors.white),
                          );
                  }),
                ),
        ],
      ),
    );
  }

  Future<bool> _handleButtonPress() async {
    controller.isSaving.value= true;
    final isModuloCompleto = _isEstadoModuloCompleto();
    if (isEdit) {
      if (isModuloCompleto && !controller.validarArchivosObligatorios()) {
        _mostrarErrores([
          "No se puede cambiar el estado del modulo a COMPLETO.",
          if (!controller.aaControlHorasExiste.value) "Falta CONTROL DE HORAS",
          if (!controller.aaExamenTeoricoExiste.value) "Falta EXAMEN TEORICO",
          if (!controller.aaExamenPracticoExiste.value) "Falta EXAMEN PRACTICO",
        ]);
        return false;
      }
    }

    final success = await controller.registrarModulo(Get.context!);
    if (success) {
      await controller.subirArchivos();
    }
    controller.isSaving.value= false;
    return success;
  }

  bool _isEstadoModuloCompleto() {
    final selectedValue =
        controller.dropdownController.getSelectedValue('estadoModulo');
    return selectedValue != null &&
        selectedValue.nombre?.toLowerCase() == 'completo';
  }

  void _mostrarErrores(List<String> errores) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }
}
