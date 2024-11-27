import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';
import '../../../../config/api/api.entrenamiento.dart';
import '../../../../shared/modules/entrenamiento.actualizacion.masiva.dart';

class ActualizacionMasivaController extends GetxController {
  RxBool isExpanded = true.obs;

  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();

  RxList<EntrenamientoActualizacionMasiva> entrenamientoResultados =
      <EntrenamientoActualizacionMasiva>[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  RxBool isLoadingGuardia = false.obs;
  final entrenamientoService = EntrenamientoService();
  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  @override
  void onInit() {
    buscarActualizacionMasiva(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
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
    try {
      var response = await entrenamientoService.actualizacionMasivaPaginado(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        inGuardia: dropdownController.getSelectedValue('guardiaFiltro')?.key,
        nombres: nombres,
        apellidos: apellidos,
        inEquipo: dropdownController.getSelectedValue('equipo')?.key,
        inModulo: dropdownController.getSelectedValue('modulo')?.key,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
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

  void clearFields() {
    codigoMcpController.clear();
    numeroDocumentoController.clear();
    nombresController.clear();
    apellidosController.clear();
    dropdownController.resetAllSelections();
  }
}
