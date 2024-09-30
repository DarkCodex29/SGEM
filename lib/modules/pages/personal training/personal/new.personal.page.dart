import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/personal%20training/personal.training.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'new.personal.controller.dart';
import 'package:intl/intl.dart';

class NuevoPersonalPage extends StatelessWidget {
  final NewPersonalController controller = NewPersonalController();
  final PersonalSearchController controllerPersonalSearch = Get.find();
  final bool isEditing;
  final bool isViewing;
  final Personal personal;
  final VoidCallback onCancel;

  NuevoPersonalPage({
    required this.isEditing,
    required this.isViewing,
    required this.personal,
    required this.onCancel,
    super.key,
  }) {
    if (isEditing || isViewing) {
      controller.dniController.text = personal.numeroDocumento;
      controller.nombresController.text =
          '${personal.primerNombre} ${personal.segundoNombre}';
      controller.puestoTrabajoController.text = personal.cargo;
      controller.codigoController.text = personal.codigoMcp;
      controller.apellidoPaternoController.text = personal.apellidoPaterno;
      controller.apellidoMaternoController.text = personal.apellidoMaterno;
      controller.gerenciaController.text = personal.gerencia;
      controller.fechaIngresoController.text =
          personal.fechaIngreso?.toString() ?? '';
      controller.areaController.text = personal.area;
      controller.codigoLicenciaController.text = personal.licenciaCategoria;
      controller.restriccionesController.text = personal.restricciones;
      controller.fechaIngresoMinaController.text =
          personal.fechaIngresoMina?.toString() ?? '';
      controller.fechaRevalidacionController.text =
          personal.licenciaVencimiento?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 30),
            _buildDatosAdicionalesSection(context),
            const SizedBox(height: 30),
            if (isViewing) _buildRegresarButton(context),
            if (!isViewing) _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
                radius: 95,
                backgroundColor: Colors.grey,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 5),
                  Text("Activo", style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(width: 30),
          Expanded(child: _buildPersonalDataFields())
        ],
      ),
    );
  }

  Widget _buildPersonalDataFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: "DNI",
                    controller: controller.dniController,
                    icon: _getSearchIcon(),
                    isReadOnly: isEditing || isViewing,
                    onIconPressed: _searchPersonalByDNI,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    label: "Nombres",
                    controller: controller.nombresController,
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    label: "Puesto de Trabajo",
                    controller: controller.puestoTrabajoController,
                    isReadOnly: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: _buildSecondColumn()),
            const SizedBox(width: 20),
            Expanded(child: _buildThirdColumn()),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Código",
          controller: controller.codigoController,
          isReadOnly: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: "Apellido Paterno",
          controller: controller.apellidoPaternoController,
          //isReadOnly: isViewing,
          isReadOnly: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: "Gerencia",
          controller: controller.gerenciaController,
          isReadOnly: true,
        ),
      ],
    );
  }

  Widget _buildThirdColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Fecha Ingreso",
          controller: controller.fechaIngresoController,
          isReadOnly: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: "Apellido Materno",
          controller: controller.apellidoMaternoController,
          //isReadOnly: isViewing,
          isReadOnly: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: "Área",
          controller: controller.areaController,
          isReadOnly: true,
        ),
      ],
    );
  }

  Widget _buildDatosAdicionalesSection(BuildContext context) {
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
          const Text(
            "Datos adicionales",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Expanded(
              //   child: CustomDropdown(
              //     hintText: "Categoría Licencia",
              //     options: const ["A", "B", "C", "D"],
              //     isSearchable: false,
              //     onChanged: isViewing ? (_) {} : (value) {},
              //     isRequired: !isViewing,
              //   ),
              // ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  label: "Categoria Licencia",
                  controller: controller.categoriaLicenciaController ,
                  isReadOnly: true,
                  isRequired: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  label: "Código Licencia",
                  controller: controller.codigoLicenciaController,
                  isReadOnly: isViewing,
                  isRequired: !isViewing,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  label: "Fecha Ingreso a Mina",
                  controller: controller.fechaIngresoMinaController,
                  icon: Icons.calendar_today,
                  isReadOnly: isViewing,
                  isRequired: !isViewing,
                  onIconPressed: () {
                    if (!isViewing) {
                      _selectDate(
                          context, controller.fechaIngresoMinaController);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  label: "Fecha de Revalidación",
                  controller: controller.fechaRevalidacionController,
                  icon: Icons.calendar_today,
                  isReadOnly: isViewing,
                  isRequired: !isViewing,
                  onIconPressed: () {
                    if (!isViewing) {
                      _selectDate(
                          context, controller.fechaRevalidacionController);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdownGuardia(controllerPersonalSearch),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text("Autorizado para operar en:"),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: isViewing ? null : (value) {},
                    ),
                    const Text("Operaciones mina"),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: true, // Control para el valor
                      onChanged: isViewing ? null : (value) {},
                    ),
                    const Text("Zonas o plataforma"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Restricciones"),
          CustomTextField(
            label: "",
            controller: controller.restriccionesController,
            isReadOnly: isViewing,
          ),
          const SizedBox(height: 20),
          _buildArchivoSection(),
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
            Text("Adjuntar archivo:"),
            SizedBox(width: 10),
            Text(
              "(Archivo adjunto peso máx: 4MB)",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                // Acción para eliminar el archivo
              },
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text("Documento.pdf",
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    );
  }

  // Botón para regresar cuando se está visualizando
  Widget _buildRegresarButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onCancel,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text("Regresar", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Botones para editar o cancelar
  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: onCancel,
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
            if (isEditing) {
              success = await controller.gestionarPersona(
                  accion: 'actualizar', context: context);
            } else {
              success = await controller.gestionarPersona(
                  accion: 'registrar', context: context);
            }
            if (success) {
              onCancel();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: const Text("Guardar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  IconData? _getSearchIcon() {
    if (!isEditing && !isViewing) {
      return Icons.search;
    }
    return null;
  }

  void _searchPersonalByDNI() async {
    if (!isEditing && !isViewing) {
      await controller.buscarPersonalPorDni(controller.dniController.text);
    }
  }

  Widget _buildDropdownGuardia(PersonalSearchController controller) {
    return Obx(() {
      if (controller.guardiaOptions.isEmpty) {
        return const CircularProgressIndicator();
      }
      List<MaestroDetalle> options = controller.guardiaOptions;
      return CustomDropdown(
        hintText: 'Selecciona Guardia',
        options: options.map((option) => option.valor).toList(),
        selectedValue: controller.selectedGuardiaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedGuardiaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedGuardiaKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedGuardiaKey.value}, Valor: $value');
        },
      );
    });
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
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
}
