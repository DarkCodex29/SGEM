import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/capacitaciones/nueva.capacitacion/nueva.capacitacion.controller.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class NuevaCapacitacionPage extends StatelessWidget {
  final bool isEditMode;
  final bool isViewing;
  final int? capacitacionKey;
  final String? dni;
  final String? codigoMcp;
  final VoidCallback onCancel;

  final NuevaCapacitacionController controller =
      Get.put(NuevaCapacitacionController());

  NuevaCapacitacionPage({
    super.key,
    required this.isEditMode,
    required this.isViewing,
    this.dni,
    this.codigoMcp,
    this.capacitacionKey,
    required this.onCancel,
  }) {
    Future.microtask(() => _initializeCapacitacion());
  }

  void _initializeCapacitacion() {
    controller.isInternoSelected.value = true;
    if (isEditMode || isViewing) {
      controller.loadCapacitacion(capacitacionKey!);
      if (controller.isInternoSelected.value) {
        controller.loadPersonalInterno(codigoMcp!, false);
      } else {
        controller.loadPersonalExterno(dni!, false);
      }
    } else {
      controller.resetControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isEditMode && !isViewing) _buildSelectorDeTipo(),
            const SizedBox(height: 20),
            Obx(() => controller.isInternoSelected.value
                ? _buildFormularioInterno()
                : _buildFormularioExterno()),
            const SizedBox(height: 20),
            _buildDatosCapacitacion(),
            const SizedBox(height: 20),
            if (isEditMode || isViewing) _buildArchivoSection(),
            const SizedBox(height: 20),
            if (!isViewing) _buildBotonesAccion(isEditMode) else SizedBox(),
            if (isViewing) _buildRegresarButton(context) else SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorDeTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            controller.seleccionarInterno();
            controller.resetControllers();
          },
          child: Obx(
            () => Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: controller.isInternoSelected.value
                    ? AppTheme.backgroundBlue
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Personal Interno",
                  style: TextStyle(
                      color: controller.isInternoSelected.value
                          ? Colors.white
                          : Colors.black54),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            controller.seleccionarExterno();
            controller.resetControllers();
          },
          child: Obx(
            () => Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: controller.isInternoSelected.value
                    ? Colors.grey[200]
                    : AppTheme.backgroundBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Personal Externo",
                  style: TextStyle(
                      color: controller.isInternoSelected.value
                          ? Colors.black54
                          : Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormularioInterno() {
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
          Obx(
            () {
              if (controller.personalPhoto.value != null) {
                try {
                  return CircleAvatar(
                    backgroundImage:
                        MemoryImage(controller.personalPhoto.value!),
                    radius: 60,
                    backgroundColor: Colors.grey,
                  );
                } catch (e) {
                  log('Error al cargar la imagen: $e');
                  return const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/user_avatar.png'),
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
            },
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEditMode && !isViewing)
                  SizedBox(
                    width: 200,
                    child: CustomTextField(
                      label: "Código MCP",
                      controller: controller.codigoMcpController,
                      icon: const Icon(Icons.search),
                      onIconPressed: () {
                        controller.loadPersonalInterno(
                            controller.codigoMcpController.text, true);
                      },
                    ),
                  ),
                if (!isEditMode) const SizedBox(height: 12),
                const Text('Datos del Personal',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "DNI",
                        controller: controller.dniInternoController,
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextField(
                        label: "Nombres",
                        controller: controller.nombresController,
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextField(
                        label: "Guardia",
                        controller: controller.guardiaController,
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioExterno() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos de la persona externa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
            child: CustomTextField(
              label: "DNI",
              controller: controller.dniExternoController,
              icon: const Icon(Icons.search),
              onIconPressed: () {
                controller.loadPersonalExterno(
                    controller.dniExternoController.text, true);
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: CustomTextField(
                  label: "Nombres",
                  controller: controller.nombresController,
                  isReadOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextField(
                  label: "Apellido Paterno",
                  controller: controller.apellidoPaternoController,
                  isReadOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextField(
                  label: "Apellido Materno",
                  controller: controller.apellidoMaternoController,
                  isReadOnly: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDatosCapacitacion() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropdownGlobal(
                  labelText: 'Categoría',
                  dropdownKey: 'categoria',
                  hintText: 'Selecciona categoría',
                  noDataHintText: 'No se encontraron categorías',
                  controller: controller.dropdownController,
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                  onChanged: (value) {
                    controller.actualizarOpcionesEmpresaCapacitadora();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomDropdownGlobal(
                  labelText: 'Empresa de capacitación',
                  dropdownKey: 'empresaCapacitacion',
                  hintText: 'Selecciona empresa de capacitación',
                  noDataHintText: 'No se encontraron empresas',
                  controller: controller.dropdownController,
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomDropdownGlobal(
                  labelText: 'Entrenador',
                  dropdownKey: 'entrenador',
                  hintText: 'Selecciona entrenador',
                  noDataHintText: 'No se encontraron entrenadores',
                  controller: controller.dropdownController,
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: "Fecha inicio",
                  controller: controller.fechaInicioController,
                  icon: const Icon(Icons.calendar_today),
                  onIconPressed: () async {
                    controller.fechaInicio = await _selectDate(Get.context!);
                    controller.fechaInicioController.text =
                        DateFormat('dd/MM/yyyy')
                            .format(controller.fechaInicio!);
                  },
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextField(
                  label: "Fecha de término",
                  controller: controller.fechaTerminoController,
                  icon: const Icon(Icons.calendar_today),
                  onIconPressed: () async {
                    //if (isViewing) return;
                    controller.fechaTermino = await _selectDate(Get.context!);
                    controller.fechaTerminoController.text =
                        DateFormat('dd/MM/yyyy')
                            .format(controller.fechaTermino!);
                  },
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextField(
                  label: "Horas de capacitación",
                  controller: controller.horasController,
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomDropdownGlobal(
                  labelText: 'Capacitación',
                  dropdownKey: 'capacitacion',
                  hintText: 'Selecciona capacitacion',
                  noDataHintText: 'No se encontraron capacitaciones',
                  controller: controller.dropdownController,
                  isReadOnly: isViewing,
                  isRequired: isViewing ? false : true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextField(
                  label: "Nota teoría",
                  controller: controller.notaTeoriaController,
                  isReadOnly: isViewing,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: CustomTextField(
                  label: "Nota práctica",
                  controller: controller.notaPracticaController,
                  isReadOnly: isViewing,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
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
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.archivosAdjuntos.isEmpty) {
            return isViewing
                ? const Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      "No hay archivos adjuntos.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.archivosAdjuntos.map((archivo) {
              return Container(
                width: 400,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        archivo['nombre'] ?? '',
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
                    if (!isViewing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          archivo['nuevo'] == false
                              ? IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Colors.blue, size: 20),
                                  onPressed: () {
                                    controller.descargarArchivo(archivo);
                                  },
                                )
                              : const SizedBox(),
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
                                controller.removerArchivo(archivo['nombre']);
                              } else {
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
        }),
        const SizedBox(height: 10),
        if (!isViewing)
          TextButton.icon(
            onPressed: () {
              controller.adjuntarDocumentos();
            },
            icon: const Icon(Icons.attach_file, color: Colors.blue),
            label: const Text(
              "Adjuntar documentos",
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  Widget _buildRegresarButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.personalPhoto.value = null;
          controller.entrenamientoModulo = null;
          controller.resetControllers();
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

  Widget _buildBotonesAccion(bool isEditMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            controller.personalPhoto.value = null;
            controller.entrenamientoModulo = null;
            controller.resetControllers();
            onCancel();
          },
          child: const Text("Cancelar"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            bool? success = false;
            if (isEditMode) {
              success = await controller.actualizarCapacitacion();
            } else {
              success = await controller.registrarCapacitacion();
            }
            if (success!) {
              controller.resetControllers();
              onCancel();
            }
          },
          child: Text(isEditMode ? "Actualizar" : "Guardar"),
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
}
