import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';

import '../../../../config/api/api.maestro.detail.dart';
import '../../../../config/api/api.modulo.maestro.dart';
import '../../../../config/api/api.training.dart';
import '../../../../shared/modules/entrenamiento.actualizacion.masiva.dart';
import '../../../../shared/modules/maestro.detail.dart';

class ActualizacionMasivaController extends GetxController {
  RxBool isExpanded = true.obs;
  var selectedGuardiaKey = RxnInt();
  var selectedEquipoKey = RxnInt();
  var selectedModuloKey = RxnInt();

  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> equipoOpciones = <MaestroDetalle>[].obs;
  RxList<ModuloMaestro> moduloOpciones = <ModuloMaestro>[].obs;

  RxList<EntrenamientoActualizacionMasiva> entrenamientoResultados =
      <EntrenamientoActualizacionMasiva>[].obs;

  final moduloMaestroService = ModuloMaestroService();
  final maestroDetalleService = MaestroDetalleService();

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  RxBool isLoadingGuardia=false.obs;
  final entrenamientoService = TrainingService();

  @override
  void onInit() {
    cargarModulo();
    cargarEquipo();
    cargarGuardia();
    buscarActualizacionMasiva(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  Future<void> cargarModulo() async {
    isLoadingGuardia.value= true;
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
    finally{
      isLoadingGuardia.value=false;
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

  Future<void> buscarActualizacionMasiva(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? numeroDocumento = numeroDocumentoController.text.isEmpty
        ? null
        : numeroDocumentoController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    String? apellidos =
        apellidosController.text.isEmpty ? null : apellidosController.text;
    log('llamando al servicio de actualizaicon masiva antes del try');
    try {
      log('llamando al servicio de actualizaicon masiva');
      var response = await entrenamientoService.ActualizacionMasivaPaginado(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        inGuardia: selectedGuardiaKey.value,
        nombres: nombres,
        apellidos: apellidos,
        inEquipo: selectedEquipoKey.value,
        inModulo: selectedModuloKey.value,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      log('Se termino de llamar al servicio de actualizacion masiva');
      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente $result');

          var items = result['Items'] as List<EntrenamientoActualizacionMasiva>;
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
      log('Error en la actualizacion masiva búsqueda 2: $e');
    }
  }
}
