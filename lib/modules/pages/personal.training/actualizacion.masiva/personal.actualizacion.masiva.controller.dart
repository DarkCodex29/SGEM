import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';

import '../../../../config/api/api.maestro.detail.dart';
import '../../../../config/api/api.modulo.maestro.dart';
import '../../../../shared/modules/entrenamiento.consulta.dart';
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

  RxList<EntrenamientoConsulta> entrenamientoResultados = <EntrenamientoConsulta>[].obs;

  final moduloMaestroService = ModuloMaestroService();
  final maestroDetalleService = MaestroDetalleService();

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  @override
  void onInit() {
    cargarModulo();
    cargarEquipo();
    cargarGuardia();
    // buscarEntrenamientos(
    //     pageNumber: currentPage.value, pageSize: rowsPerPage.value);
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

  /*
  Future<void> buscarEntrenamientos(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
    codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? nombres =
    nombresController.text.isEmpty ? null : nombresController.text;
    try {
      var response = await entrenamientoService.consultarEntrenamientoPaginado(
        codigoMcp: codigoMcp,
        inEquipo: selectedEquipoKey.value,
        inModulo: selectedModuloKey.value,
        inGuardia: selectedGuardiaKey.value,
        inEstadoEntrenamiento: selectedEstadoEntrenamientoKey.value,
        inCondicion: selectedCondicionKey.value,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        nombres: nombres,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente $result');

          var items = result['Items'] as List<EntrenamientoConsulta>;
          log('Items obtenidos: $items');

          entrenamientoResultados.assignAll(items);

          currentPage.value = result['PageNumber'] as int;
          totalPages.value = result['TotalPages'] as int;
          totalRecords.value = result['TotalRecords'] as int;
          rowsPerPage.value = result['PageSize'] as int;
          isExpanded.value = false;

          log('Resultados obtenidos: ${entrenamientoResultados.length}');
        } catch (e) {
          log('Error al procesar la respuesta: $e');
        }
      } else {
        log('Error en la búsqueda: ${response.message}');
      }
    } catch (e) {
      log('Error en la búsqueda 2: $e');
    }
  }
  */
}