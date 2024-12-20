import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.motivo.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.confirmation.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';
import '../consulta.personal.controller.dart';
import '../personal/nuevo.personal.controller.dart';
import 'entrenamiento.personal.controller.dart';
import 'modales/nuevo.entrenamiento/entrenamiento.nuevo.controller.dart';
import 'modales/nuevo.entrenamiento/entrenamiento.nuevo.modal.dart';
import 'modales/nuevo.modulo/entrenamiento.modulo.nuevo.dart';

class EntrenamientoPersonalPage extends StatelessWidget {
  final PersonalSearchController controllerPersonal;
  final NuevoPersonalController controllerNuevoPersonal =
      Get.put(NuevoPersonalController());
  final EntrenamientoPersonalController controller =
      Get.put(EntrenamientoPersonalController());
  final VoidCallback onCancel;

  EntrenamientoPersonalPage({
    required this.controllerPersonal,
    required this.onCancel,
    super.key,
  }) {
    controller.fetchTrainings(controllerPersonal.selectedPersonal.value!.key!);
    controllerNuevoPersonal.loadPersonalPhoto(
        controllerPersonal.selectedPersonal.value!.inPersonalOrigen!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPersonalDetails(),
            const SizedBox(height: 16),
            _buildTrainingListHeaderWithButton(context),
            const SizedBox(height: 16),
            Expanded(child: _buildTrainingList(context)),
            const SizedBox(height: 16),
            _buildRegresarButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controllerNuevoPersonal.personalPhoto.value != null &&
                controllerNuevoPersonal.personalPhoto.value!.isNotEmpty) {
              try {
                return CircleAvatar(
                  backgroundImage:
                      MemoryImage(controllerNuevoPersonal.personalPhoto.value!),
                  radius: 60,
                  backgroundColor: Colors.grey,
                );
              } catch (e) {
                log('Error al cargar la imagen: $e');
                return const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user_avatar.png'),
                  radius: 60,
                  backgroundColor: Colors.grey,
                );
              }
            } else {
              return const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
                radius: 60,
                backgroundColor: Colors.grey,
              );
            }
          }),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Datos del Personal',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildCustomTextField(
                        'Código',
                        controllerPersonal.selectedPersonal.value?.codigoMcp ??
                            ''),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCustomTextField(
                        'Nombres y Apellidos',
                        '${controllerPersonal.selectedPersonal.value?.primerNombre ?? ''} '
                            '${controllerPersonal.selectedPersonal.value?.apellidoPaterno ?? ''} '
                            '${controllerPersonal.selectedPersonal.value?.apellidoMaterno ?? ''}'),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCustomTextField(
                        'Guardia',
                        controllerPersonal
                                .selectedPersonal.value?.guardia!.nombre ??
                            ''),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    return SizedBox(
      width: 200,
      child: CustomTextField(
        label: label,
        controller: controller,
        isReadOnly: true,
      ),
    );
  }

  Widget _buildTrainingListHeaderWithButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Entrenamientos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: ElevatedButton.icon(
            onPressed: () async {
              var ultimoEntrenamiento =
                  await controller.obtenerUltimoEntrenamientoPorPersona(
                      controllerPersonal.selectedPersonal.value!.id);

              await showDialog(
                context: context,
                builder: (context) {
                  if (controllerPersonal.selectedPersonal.value != null) {
                    if (ultimoEntrenamiento?.estadoEntrenamiento!.nombre!
                            .toLowerCase() !=
                        "entrenando") {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Center(
                            child: EntrenamientoNuevoModal(
                                data:
                                    controllerPersonal.selectedPersonal.value!,
                                close: () {
                                  Navigator.pop(context);
                                })),
                      );
                    } else {
                      return const MensajeValidacionWidget(errores: [
                        "No puede agregar un nuevo entrenamiento, mientras el modulo anterior no ha sido completado o paralizado"
                      ]);
                    }
                  } else {
                    return const Text("Null person");
                  }
                },
              );
            },
            icon: const Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
            label: const Text('Nuevo entrenamiento',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              elevation: 2,
              minimumSize: const Size(230, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        );
      }
      if (controller.trainingList.isEmpty) {
        return const Center(child: Text('No hay entrenamientos disponibles'));
      }
      return ListView.builder(
        itemCount: controller.trainingList.length,
        itemBuilder: (context, index) {
          final training = controller.trainingList[index];
          return _buildTrainingCard(training, context);
        },
      );
    });
  }

  Widget _buildTrainingCard(
      EntrenamientoModulo training, BuildContext context) {
    return Card(
      color: const Color(0xFFF2F6FF),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                      'Equipo',
                      training.equipo!.nombre!,
                    ),
                    _buildCustomTextField(
                      'Estado de avance actual',
                      training.estadoEntrenamiento!.nombre!.toLowerCase() ==
                              'autorizado'
                          ? 'Finalizado'
                          : training.modulo!.nombre!,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.radio_button_checked,
                          color: _getColorByEstado(
                              training.estadoEntrenamiento!.key!),
                        ),
                        const SizedBox(width: 4),
                        _buildCustomTextField(
                          'Estado entrenamiento',
                          training.estadoEntrenamiento!.nombre!,
                        ),
                      ],
                    ),
                    _buildCustomTextField(
                      'Entrenador',
                      training.entrenador!.nombre!,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                      'Fecha inicio',
                      _formatDate(training.fechaInicio),
                    ),
                    _buildCustomTextField(
                      'Horas de entrenamiento',
                      _getEstadoAvanceActual(
                        training.estadoEntrenamiento!.nombre!,
                        training.inHorasAcumuladas!,
                        training.inTotalHoras!,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                      'Fecha fin',
                      _formatDate(training
                          .fechaTermino), // Formatear las fechas correctamente
                    ),
                    _buildCustomTextField(
                      'Nota teórica',
                      '${training.inNotaTeorica}', // Mostrar las notas teóricas y prácticas
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildCustomTextField(
                      'Condición',
                      training.condicion!.nombre!,
                    ),
                    _buildCustomTextField(
                      'Nota práctica',
                      '${training.inNotaPractica}',
                    ),
                  ],
                ),
                _buildActionButtons(context, training),
              ],
            ),
            Obx(
              () {
                final modulos =
                    controller.obtenerModulosPorEntrenamiento(training.key!);
                return ExpansionTile(
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text('Módulos del entrenamiento',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  children: modulos.isNotEmpty
                      ? modulos.map((modulo) {
                          return _buildModuleDetails(modulo);
                        }).toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No hay módulos disponibles'),
                          )
                        ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleDetails(EntrenamientoModulo modulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.radio_button_on,
                    color: modulo.estadoEntrenamiento!.nombre!.toLowerCase() ==
                            'completo'
                        ? Colors.green
                        : Colors.orange),
                SizedBox(
                  width: 10,
                ),
                Text(
                  modulo.modulo!.nombre!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Horas de entrenamiento:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${modulo.inHorasAcumuladas}/${modulo.inTotalHoras}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Horas minestar:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${modulo.inHorasMinestar}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nota teórica:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${modulo.inNotaTeorica}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nota práctica:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${modulo.inNotaPractica}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              if (modulo.estadoEntrenamiento!.nombre!.toLowerCase() ==
                  'completo')
                IconButton(
                  tooltip: 'Ver modulo',
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () async {
                    final bool? success = await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return GestureDetector(
                          child: Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: EntrenamientoModuloNuevo(
                              entrenamiento: modulo,
                              inPersona: modulo.inPersona,
                              inEntrenamientoModulo: modulo.key,
                              inEntrenamiento: modulo.inActividadEntrenamiento,
                              //isEdit: true,
                              isView: true,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    );
                    if (success != null && success) {
                      controller.fetchTrainings(
                          controllerPersonal.selectedPersonal.value!.key!);
                    }
                  },
                ),
              if (modulo.estadoEntrenamiento!.nombre!.toLowerCase() !=
                  'completo')
                IconButton(
                  tooltip: 'Editar modulo',
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () async {
                    final bool? success = await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return GestureDetector(
                          child: Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: EntrenamientoModuloNuevo(
                              entrenamiento: modulo,
                              inPersona: modulo.inPersona,
                              inEntrenamientoModulo: modulo.key,
                              inEntrenamiento: modulo.inActividadEntrenamiento,
                              isEdit: true,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    );
                    if (success != null && success) {
                      controller.fetchTrainings(
                          controllerPersonal.selectedPersonal.value!.key!);
                    }
                  },
                ),
              if (modulo.estadoEntrenamiento!.nombre!.toLowerCase() !=
                  'completo')
                IconButton(
                  tooltip: 'Eliminar modulo',
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    String motivoEliminacion = '';
                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: DeleteReasonWidget(
                              entityType: 'módulo - ${modulo.modulo!.nombre}',
                              isMotivoRequired: false,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: (motivo) {
                                motivoEliminacion = motivo;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    );

                    if (motivoEliminacion.isEmpty) return;

                    bool confirmarEliminar = false;
                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: ConfirmDeleteWidget(
                              itemName: 'módulo',
                              entityType: '',
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                confirmarEliminar = true;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    );

                    if (!confirmarEliminar) return;

                    bool success = await controller.eliminarModulo(modulo);

                    if (success) {
                      await showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return const SuccessDeleteWidget();
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        const SnackBar(
                          content: Text("Error al eliminar el módulo."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    EntrenamientoModulo entrenamiento,
  ) {
    final status = entrenamiento.estadoEntrenamiento!.nombre!.toLowerCase();
    final isAutorizado = status == 'autorizado';

    final modulos =
        controller.obtenerModulosPorEntrenamiento(entrenamiento.key!);

    modulos.sort((a, b) => a.inModulo!.compareTo(b.inModulo!));

    final lastModule = modulos.isNotEmpty ? modulos.last.inModulo : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            if (!isAutorizado)
              IconButton(
                tooltip: 'Editar entrenamiento',
                icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                onPressed: () async {
                  EntrenamientoNuevoController controllerModal =
                      Get.put(EntrenamientoNuevoController());
                  await controllerModal.getEquiposAndConditions();
                  final EntrenamientoModulo? updatedTraining = await showDialog(
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Center(
                          child: EntrenamientoNuevoModal(
                            data: controllerPersonal.selectedPersonal.value!,
                            isEdit: true,
                            entrenamiento: entrenamiento,
                            lastModulo: lastModule,
                            close: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  );
                  log("Entrenamiento: $updatedTraining");
                  if (updatedTraining != null) {
                    bool success = await controller
                        .actualizarEntrenamiento(updatedTraining);
                    if (success) {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Entrenamiento actualizado correctamente"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
              ),
            if (entrenamiento.estadoEntrenamiento!.nombre!.toLowerCase() !=
                'autorizado')
              IconButton(
                tooltip: 'Eliminar entrenamiento',
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  String motivoEliminacion = '';

                  log('Entrenamiento: ${entrenamiento.key!}');
                  var response = await controller.entrenamientoService
                      .obtenerUltimoModuloPorEntrenamiento(entrenamiento.key!);
                  var ultimoModulo = response.data!;
                  log('Eliminar Entrenamiento: ${ultimoModulo.inModulo}');
                  if (ultimoModulo.inModulo != null &&
                      ultimoModulo.inModulo! >= 1) {
                    log('Existe modulo ${ultimoModulo.inModulo}');
                    showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return MensajeValidacionWidget(errores: [
                          'No se puede eliminar un ENTRENAMIENTO que ya tiene un MODULO registrado'
                        ]);
                      },
                    );
                    return;
                  }

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: DeleteReasonWidget(
                            entityType: 'entrenamiento',
                            isMotivoRequired: false,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: (motivo) {
                              motivoEliminacion = motivo;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  );

                  if (motivoEliminacion.isEmpty) return;

                  bool confirmarEliminar = false;
                  await showDialog(
                    context: Get.context!,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: ConfirmDeleteWidget(
                            itemName: 'entrenamiento',
                            entityType: '',
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              confirmarEliminar = true;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  );

                  if (!confirmarEliminar) return;
                  try {
                    bool success =
                        await controller.eliminarEntrenamiento(entrenamiento);
                    if (success) {
                      await showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return const SuccessDeleteWidget();
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        const SnackBar(
                          content: Text("Error al eliminar el entrenamiento."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    log('Error eliminando el entrenamiento: $e');
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(
                        content: Text("Error eliminando el entrenamiento: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            if (entrenamiento.estadoEntrenamiento!.nombre!.toLowerCase() ==
                "entrenando")
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: AppTheme.primaryColor),
                tooltip: 'Nuevo modulo',
                onPressed: () async {
                  log('Entrenamiento: ${entrenamiento.key!}');
                  var response = await controller.entrenamientoService
                      .obtenerUltimoModuloPorEntrenamiento(entrenamiento.key!);
                  var ultimoModulo = response.data!;
                  if (ultimoModulo.inModulo != 4) {
                    log("Ultimo modulo: ${ultimoModulo.inModulo}");
                    //log('Estado ultimo modulo: ${ultimoModulo.estadoEntrenamiento!.nombre}');
                    if (ultimoModulo.inModulo != null &&
                        ultimoModulo.inModulo! >= 1 &&
                        ultimoModulo.estadoEntrenamiento!.nombre!
                                .toLowerCase() !=
                            'completo') {
                      log('Estado ultimo modulo: ${ultimoModulo.estadoEntrenamiento!.nombre}');
                      showDialog(
                          context: Get.context!,
                          builder: (context) {
                            return const MensajeValidacionWidget(errores: [
                              "No se puede agregar un NUEVO MODULO mientras el módulo anterior no haya sido COMPLETADO."
                            ]);
                          });
                    } else {
                      final bool? success = await showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return GestureDetector(
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: EntrenamientoModuloNuevo(
                                entrenamiento: entrenamiento,
                                isEdit: false,
                                inEntrenamiento: entrenamiento.key,
                                inPersona: entrenamiento.inPersona,
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                      if (success != null && success) {
                        await controller.fetchTrainings(
                            controllerPersonal.selectedPersonal.value!.key!);
                      }
                    }
                  } else {
                    showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return const MensajeValidacionWidget(errores: [
                            "No se puede agregar más módulos",
                          ]);
                        });
                  }
                },
              ),
          ],
        ),
        if (entrenamiento.estadoEntrenamiento!.nombre!.toLowerCase() ==
            "autorizado")
          Row(
            children: [
              IconButton(
                tooltip: 'Ver diploma',
                icon:
                    const Icon(Icons.stars_sharp, color: AppTheme.primaryColor),
                onPressed: () {
                  controllerPersonal.showDiploma();
                },
              ),
              IconButton(
                tooltip: 'Ver certificado',
                icon: const Icon(Icons.file_copy_sharp,
                    color: AppTheme.primaryColor),
                onPressed: () {
                  controller.selectedTraining.value = entrenamiento;
                  controllerPersonal.showCertificado();
                },
              ),
            ],
          )
      ],
    );
  }

  Widget _buildRegresarButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onCancel();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text("Regresar", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getEstadoAvanceActual(
      String estadoEntrenamiento, int horasAcumuladas, int totalHoras) {
    return '$horasAcumuladas / $totalHoras';
  }

  Color _getColorByEstado(int estado) {
    switch (estado) {
      case 13:
        return Colors.green; // AUTORIZADO
      case 11:
        return Colors.orange; // ENTRENANDO
      case 12:
        return Colors.red; //PARALIZADO
      default:
        return Colors.grey;
    }
  }
}
