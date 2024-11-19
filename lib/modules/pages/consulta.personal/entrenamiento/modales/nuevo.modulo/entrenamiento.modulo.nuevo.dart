import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
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
            height: isEdit == false ? 600 : 800,
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
            'Control de horas', controller.aaControlHorasController.text,
            () async {
          controller.cargarArchivoControlHoras();
        }, () {}),
        _buildAdjuntoRow(
            'Examen Teórico', controller.aaExamenTeoricoController.text,
            () async {
          controller.cargarArchivoExamenTeorico();
        }, () {}),
        _buildAdjuntoRow(
            'Examen Práctico', controller.aaExamenPracticoController.text,
            () async {
          controller.cargarArchivoExamenPractico();
        }, () {}),
        _buildAdjuntoRow('Otros', controller.aaOtrosController.text, () async {
          controller.cargarArchivoOtros();
        }, () {}),
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
    String nombreArchivo,
    VoidCallback onPressed,
    VoidCallback onRemove,
  ) {
    return Row(
      children: [
        Text(titulo),
        const SizedBox(width: 10),
        IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.attach_file, color: Colors.grey)),
        const SizedBox(width: 10),
        // TODO: Aquí puedes mostrar el nombre del archivo subido si está disponible
        Text(
          nombreArchivo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: onRemove,
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
