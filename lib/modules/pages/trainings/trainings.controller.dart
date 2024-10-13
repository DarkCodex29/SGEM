import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.training.dart';
import 'package:sgem/shared/modules/training.dart';

class TrainingsController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();
  TextEditingController nombresController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  final entrenamientoService = TrainingService();
  RxBool isExpanded = true.obs;
  var entrenamientoResultados = <Entrenamiento>[].obs;

  var selectedEquipoKey = RxnInt();
  var selectedModuloKey = RxnInt();
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoEntrenamientoKey = RxnInt();
  var selectedCondicionKey = RxnInt();

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  @override
  void onInit() {
    //cargarGuardiaOptions();
    buscarEntrenamientos(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

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

          var items = result['Items'] as List<Entrenamiento>;
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

  void clearFields() {}
}
