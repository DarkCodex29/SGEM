import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/personal.training/training/modales/new%20training/entrenamiento.nuevo.controller.dart';
import 'package:sgem/modules/pages/personal.training/personal.training.controller.dart';
import 'package:sgem/modules/pages/personal.training/personal/new.personal.controller.dart';
import 'package:sgem/modules/pages/personal.training/training/training.personal.controller.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.motivo.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.confirmation.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';
import 'package:sgem/modules/pages/personal.training/training/modales/new%20module/entrenamiento.modulo.nuevo.dart';
import 'modales/new training/entrenamiento.nuevo.modal.dart';

class TrainingPersonalPage extends StatelessWidget {
  final PersonalSearchController controllerPersonal;
  final NewPersonalController controllerNewPersonal =
      Get.put(NewPersonalController());
  final TrainingPersonalController controller =
      Get.put(TrainingPersonalController());
  final VoidCallback onCancel;

  TrainingPersonalPage({
    required this.controllerPersonal,
    required this.onCancel,
    super.key,
  }) {
    controller.fetchTrainings(controllerPersonal.selectedPersonal.value!.key);
    controllerNewPersonal.loadPersonalPhoto(
        controllerPersonal.selectedPersonal.value!.inPersonalOrigen);
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
            if (controllerNewPersonal.personalPhoto.value != null &&
                controllerNewPersonal.personalPhoto.value!.isNotEmpty) {
              try {
                return CircleAvatar(
                  backgroundImage:
                      MemoryImage(controllerNewPersonal.personalPhoto.value!),
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
                                .selectedPersonal.value?.guardia.nombre ??
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
              await showDialog(
                context: context,
                builder: (context) {
                  if (controllerPersonal.selectedPersonal.value != null) {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Center(
                          child: EntrenamientoNuevoModal(
                              data: controllerPersonal.selectedPersonal.value!,
                              close: () {
                                Navigator.pop(context);
                              })),
                    );
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
                      'Código de entrenamiento',
                      training.key.toString(),
                    ),
                    _buildCustomTextField(
                      'Estado de avance actual',
                      training.modulo.nombre,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                      'Equipo',
                      training.equipo.nombre,
                    ),
                    _buildCustomTextField(
                      'Entrenador',
                      training.entrenador.nombre,
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
                              training.estadoEntrenamiento.key),
                        ),
                        const SizedBox(width: 4),
                        _buildCustomTextField(
                          'Estado entrenamiento',
                          training.estadoEntrenamiento.nombre,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.radio_button_on, color: Colors.green),
                        const SizedBox(width: 4),
                        _buildCustomTextField(
                          'Estado de avance actual',
                          _getEstadoAvanceActual(
                              training.estadoEntrenamiento.nombre,
                              training.inHorasAcumuladas,
                              training.inTotalHoras),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                      'Fecha inicio / Fin',
                      '${_formatDate(training.fechaInicio)} / ${_formatDate(training.fechaTermino)}', // Formatear las fechas correctamente
                    ),
                    _buildCustomTextField(
                      'Nota teórica / práctica',
                      '${training.inNotaTeorica} / ${training.inNotaPractica}', // Mostrar las notas teóricas y prácticas
                    ),
                  ],
                ),
                _buildCustomTextField(
                  'Condición',
                  training.condicion.nombre,
                ),
                _buildActionButtons(context, training),
              ],
            ),
            Obx(() {
              final modulos =
                  controller.obtenerModulosPorEntrenamiento(training.key);
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
            }),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modulo.modulo.nombre,
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
              IconButton(
                icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                onPressed: () {
                  Get.snackbar(
                      'Editar módulo', 'Módulo actualizado correctamente',
                      colorText: Colors.white, backgroundColor: Colors.green);
                },
              ),
              IconButton(
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
                            entityType: 'módulo',
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
      BuildContext context, EntrenamientoModulo training) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
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
                          training: training,
                          close: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );

                if (updatedTraining != null) {
                  bool success =
                      await controller.actualizarEntrenamiento(updatedTraining);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
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
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                String motivoEliminacion = '';

                await showDialog(
                  context: context,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: DeleteReasonWidget(
                          entityType: 'entrenamiento',
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
                  context: context,
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
                      await controller.eliminarEntrenamiento(training);
                  if (success) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return const SuccessDeleteWidget();
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error al eliminar el entrenamiento."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  log('Error eliminando el entrenamiento: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error eliminando el entrenamiento: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppTheme.primaryColor),
              onPressed: () async {
                final bool? success = await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  context: Get.context!,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: EntrenamientoModuloNuevo(
                          entrenamiento: training,
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
                      controllerPersonal.selectedPersonal.value!.key);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.stars_sharp, color: AppTheme.primaryColor),
              onPressed: () {
                controllerPersonal.showDiploma();
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_copy_sharp,
                  color: AppTheme.primaryColor),
              onPressed: () {
                controllerPersonal.showCertificado();
              },
            ),
          ],
        ),
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
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String _getEstadoAvanceActual(
      String estadoEntrenamiento, int horasAcumuladas, int totalHoras) {
    if (estadoEntrenamiento.toLowerCase() == 'autorizado') {
      return 'Finalizado';
    } else {
      return '$horasAcumuladas/$totalHoras';
    }
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
