import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/administracion/maestro/maestro.controller.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/dropDown/custom.dropdown.global.dart';
import '../../../../shared/widgets/custom.textfield.dart';

class MaestroPage extends StatelessWidget {
  const MaestroPage({super.key, required this.onCancel});
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final MaestroController controller = Get.put(MaestroController());

    return Scaffold(
      body: _buildMantenimientoMaestro(
        controller,
        context,
      ),
    );
  }

  Widget _buildMantenimientoMaestro(
      MaestroController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSeccionFiltros(context, controller),
              const SizedBox(
                height: 20,
              ),
              _buildSeccionResultado(controller),
              const SizedBox(
                height: 20,
              ),
              _buildRegresarButton(context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeccionFiltros(
      BuildContext context, MaestroController controller) {
    return ExpansionTile(
      initiallyExpanded: controller.isExpanded.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Filtros de Busqueda",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _buildSeccionConsultaPrimeraFila(controller),
              //_buildSeccionConsultaSegundaFila(controller),
              //_buildSeccionConsultaTerceraFila(context, controller),
              _buildBotonesAccion(controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaPrimeraFila(MaestroController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildDropdownMaestro(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Valor",
            controller: controller.valorController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildDropdownGuardia(controller),
        ),
      ],
    );
  }

  Widget _buildDropdownMaestro(MaestroController controller) {
    return Obx(() {
      if (controller.isLoadingMaestro.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }
      // if (controller.maestroOpciones.isEmpty) {
      //   return const Center(
      //     child: Text(
      //       'No se encontraron maestros',
      //       style: TextStyle(fontSize: 16, color: Colors.black54),
      //     ),
      //   );
      // }
      //List<MaestroDetalle> options = controller.guardiaOpciones;
      List options = controller.maestroOpciones;
      return CustomDropdownGlobal(
        dropdownKey: 'maestro',
        noDataHintText: 'No se encontraron maestros',
        isReadOnly: controller.maestroOpciones.isEmpty ? true : false,
        hintText: controller.maestroOpciones.isEmpty
            ? 'No se encontraron maestros'
            : 'Maestro',
        // options: options.map((option) => option.valor!).toList(),
        staticOptions: const [],
        /*
        selectedValue: controller.selectedMaestroKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedMaestroKey.value)
                .valor
            : null,
            */
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          // final selectedOption = options.firstWhere(
          //       (option) => option.valor == value,
          // );
          // controller.selectedMaestroKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedMaestroKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownGuardia(MaestroController controller) {
    return Obx(() {
      if (controller.isLoadingEstado.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      // if (controller.estadoOpciones.isEmpty) {
      //   return const Center(
      //     child: Text(
      //       'No se encontraron estados',
      //       style: TextStyle(fontSize: 16, color: Colors.black54),
      //     ),
      //   );
      // }
      // List<MaestroDetalle> options = controller.guardiaOpciones;

      List options = [];
      return CustomDropdownGlobal(
        dropdownKey: 'estado',
        noDataHintText: 'No se encontraron estados',
        isReadOnly: controller.estadoOpciones.isEmpty ? true : false,
        hintText: controller.estadoOpciones.isEmpty
            ? 'No se encontraron estados'
            : 'Estado',
        //options: options.map((option) => option.valor!).toList(),
        staticOptions: const [],
        /*
        selectedValue: controller.selectedEstadoKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedEstadoKey.value)
                .valor
            : null,
            */
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedEstadoKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedEstadoKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildBotonesAccion(MaestroController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            //controller.clearFields();
            // await controller.buscarActualizacionMasiva();
            // controller.isExpanded.value = false;
          },
          icon: const Icon(
            Icons.cleaning_services,
            size: 18,
            color: AppTheme.primaryText,
          ),
          label: const Text(
            "Limpiar",
            style: TextStyle(fontSize: 16, color: AppTheme.primaryText),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.alternateColor),
            ),
            elevation: 2,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            //await controller.buscarActualizacionMasiva();
            // controller.isExpanded.value = false;
          },
          icon: const Icon(
            Icons.search,
            size: 18,
            color: Colors.white,
          ),
          label: const Text(
            "Buscar",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionResultado(MaestroController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSeccionResultadoBarraSuperior(controller),
          const SizedBox(
            height: 20,
          ),
          _buildSeccionResultadoTabla(controller),
          const SizedBox(
            height: 20,
          ),
          //_buildSeccionResultadoTablaPaginado(controller),
        ],
      ),
    );
  }

  Widget _buildSeccionResultadoBarraSuperior(MaestroController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Maestros",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            //controller.showNewPersonal();
          },
          icon: const Icon(Icons.add,
              size: 18, color: AppTheme.primaryBackground),
          label: const Text(
            "Nuevo elemento",
            style: TextStyle(fontSize: 16, color: AppTheme.primaryBackground),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionResultadoTabla(MaestroController controller) {
    return Obx(
      () {
        // if (controller.maestroResultado.isEmpty) {
        //   return const Center(child: Text("No se encontraron resultados"));
        // }

        var rowsToShow = controller.maestroResultado
            .take(controller.rowsPerPage.value)
            .toList();

        return Column(
          children: [
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              child: _buildSeccionResultadoTablaCabezera(),
            ),
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: rowsToShow.map((entrenamiento) {
                    return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildSeccionResultadoTablaData(entrenamiento));
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSeccionResultadoTablaCabezera() {
    const boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

    return const Row(
      children: [
        Expanded(flex: 1, child: Text('Código', style: boldTextStyle)),
        Expanded(flex: 1, child: Text('Maestro', style: boldTextStyle)),
        Expanded(flex: 1, child: Text('Valor', style: boldTextStyle)),
        Expanded(
            flex: 1, child: Text('Usuario registro', style: boldTextStyle)),
        Expanded(flex: 1, child: Text('Fecha registro', style: boldTextStyle)),
        Expanded(flex: 1, child: Text('Estado', style: boldTextStyle)),
        Expanded(flex: 1, child: Text('Acción', style: boldTextStyle)),
      ],
    );
  }

  Widget _buildSeccionResultadoTablaData(dynamic data) {
    return const Row(
      children: [
        // Expanded(child: Text(data.codigoMcp!)),
        // Expanded(child: Text(data.nombreCompleto!)),
        // Expanded(child: Text(data.guardia!.nombre!)),
        // Expanded(child: Text(data.equipo!.nombre!)),
        // Expanded(child: Text(data.modulo!.nombre!)),
        // Expanded(
        //     child: Text(
        //       data.inNotaPractica.toString(),
        //       textAlign: TextAlign.center,
        //     )),
        // Expanded(
        //     child: Text(
        //       data.inNotaTeorica.toString(),
        //       textAlign: TextAlign.center,
        //     )),
        // //Todo: Cambiar por fecha de examen
        // Expanded(
        //   child: Text(DateFormat('dd/MM/yyyy')
        //       .format(entrenamiento.fechaExamen as DateTime)),
        // ),
        // Expanded(
        //     child: Text(
        //       entrenamiento.inHorasAcumuladas.toString(),
        //       textAlign: TextAlign.center,
        //     )),
        // Expanded(
        //   child: Text(DateFormat('dd/MM/yyyy')
        //       .format(entrenamiento.fechaInicio!)),
        // ),
        // Expanded(
        //   child: Text(DateFormat('dd/MM/yyyy')
        //       .format(entrenamiento.fechaTermino!)),
        // ),
        // //Todo: Botones de accion
        // Expanded(
        //   child: _buildIconButton(
        //       Icons.edit, AppTheme.primaryColor, () {
        //     //controller.showEditPersonal(personal);
        //   }),
        // ),
      ],
    );
  }

  Widget _buildRegresarButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          //controller.resetControllers();
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
