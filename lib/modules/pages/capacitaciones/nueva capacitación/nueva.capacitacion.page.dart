import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/capacitaciones/nueva%20capacitaci%C3%B3n/nueva.capacitacion.controller.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';

class NuevaCapacitacionPage extends StatelessWidget {
  const NuevaCapacitacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    NuevaCapacitacionController controller =
        Get.put(NuevaCapacitacionController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Capacitación"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(controller),
            const SizedBox(height: 20),
            _buildDatosDelPersonal(controller),
            const SizedBox(height: 20),
            _buildFormularioCapacitacion(controller),
            const SizedBox(height: 20),
            _buildArchivosAdjuntos(controller),
            const SizedBox(height: 20),
            _buildBotonesAccion(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(NuevaCapacitacionController controller) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: "Código MCP",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Obx(() {
            return CustomDropdown(
              hintText: 'Selecciona Tipo',
              options: const ['Personal Interno', 'Persona Externa'],
              selectedValue: controller.tipoSeleccionado.value,
              onChanged: (value) {
                controller.tipoSeleccionado.value = value!;
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDatosDelPersonal(NuevaCapacitacionController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos del Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: "Código",
                  controller: controller.codigoController,
                  isReadOnly: true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextField(
                  label: "Nombres y Apellidos",
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
    );
  }

  Widget _buildFormularioCapacitacion(NuevaCapacitacionController controller) {
    return ExpansionTile(
      title: const Text(
        "Datos de la Capacitación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Categoría',
                      options: controller.categoriaOpciones,
                      selectedValue: controller.categoriaSeleccionada.value,
                      onChanged: (value) {
                        controller.categoriaSeleccionada.value = value!;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Empresa de Capacitación',
                      options: controller.empresaOpciones,
                      selectedValue: controller.empresaSeleccionada.value,
                      onChanged: (value) {
                        controller.empresaSeleccionada.value = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Horas de Capacitación",
                      controller: controller.horasController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      label: "Entrenador Responsable",
                      controller: controller.entrenadorController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Fecha de Inicio",
                      controller: controller.fechaInicioController,
                      icon: const Icon(Icons.calendar_today),
                      onIconPressed: () {
                        // Lógica para seleccionar la fecha
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      label: "Fecha de Término",
                      controller: controller.fechaTerminoController,
                      icon: const Icon(Icons.calendar_today),
                      onIconPressed: () {
                        // Lógica para seleccionar la fecha
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Nombre de la Capacitación",
                controller: controller.nombreCapacitacionController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArchivosAdjuntos(NuevaCapacitacionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Archivos Adjuntos",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {
            controller.adjuntarDocumento();
          },
          icon: const Icon(Icons.attach_file),
          label: const Text("Adjuntar Documento"),
        ),
        Obx(() {
          if (controller.archivosAdjuntos.isEmpty) {
            return const Text("No hay archivos adjuntos.");
          }
          return Column(
            children: controller.archivosAdjuntos.map((archivo) {
              return ListTile(
                title: Text(archivo['nombre']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.eliminarArchivo(archivo);
                  },
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildBotonesAccion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Lógica para cancelar
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar la capacitación
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
