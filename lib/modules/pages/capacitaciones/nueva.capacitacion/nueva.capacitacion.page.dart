import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/capacitaciones/nueva.capacitacion/nueva.capacitacion.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class NuevaCapacitacionPage extends StatelessWidget {
  NuevaCapacitacionPage({super.key});
  final NuevaCapacitacionController controller =
      Get.put(NuevaCapacitacionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSelectorDeTipo(),
            const SizedBox(height: 20),
            Obx(() => controller.isInternoSelected.value
                ? _buildFormularioInterno()
                : _buildFormularioExterno()),
            const SizedBox(height: 20),
            _buildDatosCapacitacion(),
            const SizedBox(height: 20),
            _buildArchivosAdjuntos(),
            const SizedBox(height: 20),
            _buildBotonesAccion(context),
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
          onTap: () => controller.seleccionarInterno(),
          child: Obx(() => Container(
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: controller.isInternoSelected.value
                      ? AppTheme.backgroundBlue
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text(
                  "Personal Interno",
                  style: TextStyle(color: Colors.white),
                )),
              )),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => controller.seleccionarExterno(),
          child: Obx(() => Container(
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: controller.isInternoSelected.value
                      ? Colors.grey[200]
                      : AppTheme.backgroundBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text("Persona Externa",
                        style: TextStyle(color: Colors.white))),
              )),
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
          Obx(() {
            if (controller.personalPhoto.value != null &&
                controller.personalPhoto.value!.isNotEmpty) {
              try {
                return CircleAvatar(
                  backgroundImage: MemoryImage(controller.personalPhoto.value!),
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
                SizedBox(
                  width: 200,
                  child: CustomTextField(
                    label: "Código MCP",
                    controller: controller.dniController,
                    icon: const Icon(Icons.search),
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Datos del Personal',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildCustomTextField('Código', ''),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCustomTextField('DNI', ''),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCustomTextField('Nombres y Apellidos', ''),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCustomTextField(
                        'Guardia',
                        controller.selectedPersonal.value?.guardia.nombre ??
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
          CustomTextField(
            label: "DNI",
            controller: controller.dniController,
            icon: const Icon(Icons.search),
            onIconPressed: () {},
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: CustomTextField(
                  label: "Nombres",
                  controller: controller.nombresController,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextField(
                  label: "Apellido Paterno",
                  controller: controller.apellidoPaternoController,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextField(
                  label: "Apellido Materno",
                  controller: controller.apellidoMaternoController,
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
                child: _buildDropdownCategoria(controller),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomDropdown(
                hintText: "Empresa de capacitación",
                options: controller.empresaOpciones,
                onChanged: (p0) {
                  controller.empresaSeleccionada.value = p0;
                },
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomDropdown(
                hintText: "Entrenador responsable",
                options: controller.entrenadorOpciones,
                onChanged: (value) {
                  controller.entrenadorSeleccionado.value = value;
                },
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                      label: "Fecha inicio",
                      controller: controller.fechaInicioController)),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomTextField(
                      label: "Fecha de término",
                      controller: controller.fechaTerminoController)),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomTextField(
                      label: "Horas de capacitación",
                      controller: controller.horasController)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomDropdown(
                    hintText: "Nombre de capacitación",
                    options: controller.nombreCapacitacion,
                    onChanged: (value) {
                      controller.nombreCapacitacionSeleccionada.value = value;
                    }),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomTextField(
                      label: "Nota teoría",
                      controller: controller.notaTeoriaController)),
              const SizedBox(width: 20),
              Expanded(
                  child: CustomTextField(
                      label: "Nota práctica",
                      controller: controller.notaPracticaController)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCategoria(NuevaCapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingCategoria.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.categoriaOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron categorias',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }
      List<MaestroDetalle> options = controller.categoriaOpciones;
      return CustomDropdown(
        hintText: 'Categoria',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedCategoriaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedCategoriaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedCategoriaKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedCategoriaKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildArchivosAdjuntos() {
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
          const Row(
            children: [
              Icon(Icons.attach_file, color: Colors.grey),
              SizedBox(width: 10),
              Text("Archivos adjuntos:"),
              SizedBox(width: 10),
              Text(
                "(Archivos adjuntos peso máx: 8MB c/u)",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.archivosAdjuntos.isEmpty) {
              return const Text("No hay archivos adjuntos.");
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.archivosAdjuntos.map((archivo) {
                  return Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          controller.eliminarArchivo(archivo['nombre']);
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: Text(
                          archivo['nombre'] ?? '',
                          style: TextStyle(
                            color: archivo['nuevo'] == true
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }
          }),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              controller.adjuntarDocumentos();
            },
            icon: const Icon(Icons.attach_file, color: Colors.blue),
            label: const Text("Adjuntar Documentos",
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            //controller.limpiarFormulario();
          },
          child: const Text("Cancelar"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Get.snackbar("Guardado",
                "Los datos de la capacitación se han guardado correctamente.");
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
