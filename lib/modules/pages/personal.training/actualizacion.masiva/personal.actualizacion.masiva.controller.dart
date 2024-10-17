import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';

import '../../../../config/api/api.maestro.detail.dart';
import '../../../../config/api/api.modulo.maestro.dart';
import '../../../../shared/modules/maestro.detail.dart';

class  ActualizacionMasivaController extends GetxController{
  RxBool isExpanded = true.obs;
  RxnInt selectedGuardiaKey = RxnInt();
  RxnInt selectedEquipoKey = RxnInt();
  RxnInt selectedModuloKey = RxnInt();

  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController documentoIdentidadController = TextEditingController();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> equipoOpciones = <MaestroDetalle>[].obs;
  RxList<ModuloMaestro> moduloOpciones = <ModuloMaestro>[].obs;

  final moduloMaestroService = ModuloMaestroService();
  final maestroDetalleService = MaestroDetalleService();

  @override
  void onInit() {
    cargarModulo();
    cargarEquipo();
    cargarGuardia();
   // cargarEstadoEntrenamiento();
    //cargarCondicion();
   // buscarEntrenamientos(
    //    pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  Future<void> cargarModulo() async {
    try {
      var response = await moduloMaestroService.listarMaestros();

      if (response.success && response.data != null) {
        moduloOpciones.assignAll(response.data!);

        log('Modulos maestro opciones cargadas correctamente: $guardiaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de Modulos maestro: $e');
    }
  }
  Future<void> cargarEquipo() async {
    try {
      var response = await maestroDetalleService
          .listarMaestroDetallePorMaestro(5); //Maestro de Equipos

      if (response.success && response.data != null) {
        equipoOpciones.assignAll(response.data!);

        log('Equipos opciones cargadas correctamente: $equipoOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }
  Future<void> cargarGuardia() async {
    try {
      var response =
      await maestroDetalleService.listarMaestroDetallePorMaestro(2);

      if (response.success && response.data != null) {
        guardiaOpciones.assignAll(response.data!);

        log('Guardia opciones cargadas correctamente: $guardiaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }
}