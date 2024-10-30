import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import '../../../../../../config/theme/app_theme.dart';
import '../../../../../../shared/widgets/custom.textfield.dart';
import '../../../../../../shared/widgets/dropDown/custom.dropdown.dart';
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

  EntrenamientoModuloNuevo({
    super.key,
    required this.onCancel,
    this.entrenamiento,
    this.isEdit = false,
    this.inEntrenamientoModulo,
    this.inEntrenamiento,
    this.inPersona,
  });

  @override
  Widget build(BuildContext context) {
    //controller.setDatosEntrenamiento(entrenamiento!, isEdit);

    if (inEntrenamientoModulo != null) {
      controller.obtenerModuloPorId(inEntrenamientoModulo!);
    }

    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          width: 800,
          height: 600,
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
                    _buildBotones(context)
                  ],
                ),
              )
            ],
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
          child: CustomDropdown(
            dropdownKey: 'entrenador',
            hintText: "Responsable",
            noDataHintText: 'No se encontraron entrenadores',
            controller: controller.dropdownController,
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
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
            ),
            CustomTextField(
              label: 'Práctico',
              controller: controller.notaPracticaController,
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
            ),
            CustomTextField(
              label: 'Horas minestar',
              controller: controller.horasMinestarController,
              icon: const Icon(Icons.lock_clock_outlined),
            ),
          ],
        ),
      ),
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
              success = await controller.registrarModulo(context);
              if (success) {
                onCancel();
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