import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/personal.training/personal.training.controller.dart';
import 'package:sgem/modules/pages/personal.training/personal/new.personal.controller.dart';
import 'package:sgem/modules/pages/personal.training/training/training.personal.controller.dart';
import 'package:sgem/shared/modules/training.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.motivo.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.confirmation.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';
import 'package:sgem/shared/widgets/entrenamiento.modulo/widget.entrenamiento.modulo.nuevo.dart';
import '../../../dialogs/entrenamiento/entrenamiento.nuevo.modal.dart';

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
                    SizedBox(width: 20,),
                    _buildCustomTextField(
                        'Nombres y Apellidos',
                        '${controllerPersonal.selectedPersonal.value?.primerNombre ?? ''} '
                            '${controllerPersonal.selectedPersonal.value?.apellidoPaterno ?? ''} '
                            '${controllerPersonal.selectedPersonal.value?.apellidoMaterno ?? ''}'),
                    SizedBox(width: 20,),
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

  Widget _buildTrainingCard(Entrenamiento training, BuildContext context) {
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
                        'Código de entrenamiento', training.key.toString()),
                    _buildCustomTextField('Estado de avance actual',
                        training.inModulo.toString()),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                        'Equipo', training.inEquipo.toString()),
                    _buildCustomTextField(
                        'Entrenador', training.inEntrenador.toString()),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked,
                            color: Colors.orange),
                        const SizedBox(width: 4),
                        _buildCustomTextField('Estado entrenamiento',
                            training.inEstado.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.radio_button_on, color: Colors.green),
                        const SizedBox(width: 4),
                        _buildCustomTextField('Horas de entrenamiento',
                            '${training.inHorasAcumuladas}/${training.inTotalHoras}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField('Fecha inicio / Fin',
                        '${training.fechaInicio} / ${training.fechaTermino}'),
                    _buildCustomTextField('Nota teórica / práctica',
                        '${training.inNotaTeorica} / ${training.inNotaPractica}'),
                  ],
                ),
                _buildCustomTextField(
                    'Condición', training.inCondicion.toString()),
                _buildActionButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Center(
                        child: EntrenamientoNuevoModal(
                          data: controllerPersonal.selectedPersonal.value!,
                          isEdit: true,
                          close: () {
                            Navigator.pop(context);
                          },
                          training: controller.trainingList[0],
                        ),
                      ),
                    );
                  },
                );
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
                  bool success = await controller.eliminarEntrenamiento(
                    controller.trainingList[0],
                  );

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
                await showModalBottomSheet(
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
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
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
}

