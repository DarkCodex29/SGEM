import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/capacitacion.consulta.dart';
import 'package:sgem/shared/modules/personal.dart';

import '../../../config/api/api.maestro.detail.dart';
import '../../../shared/modules/maestro.detail.dart';

class CapacitacionController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidoPaternoController = TextEditingController();
  TextEditingController apellidoMaternoController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  RxBool isExpanded = true.obs;
  RxBool isLoadingGuardia = false.obs;
  RxBool isLoadingCapacitacion = false.obs;
  RxBool isLoadingCategoria = false.obs;
  RxBool isLoadingEmpresaCapacitacion = false.obs;
  RxBool isLoadingCapacitacionResultados = false.obs;
  RxBool isLoadingEntrenador = false.obs;

  var selectedGuardiaKey = RxnInt();
  var selectedCapacitacionKey = RxnInt();
  var selectedCategoriaKey = RxnInt();
  var selectedEmpresaCapacitacionKey = RxnInt();
  var selectedEntrenadorKey = RxnInt();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> capacitacionOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> categoriaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> empresaCapacitacionOpciones = <MaestroDetalle>[].obs;
  RxList<Personal> entrenadorOpciones = <Personal>[].obs;

  final maestroDetalleService = MaestroDetalleService();
  final personalService = PersonalService();
  final capacitacionService = CapacitacionService();
  RxList<CapacitacionConsulta> capacitacionResultados =
      <CapacitacionConsulta>[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  @override
  void onInit() {
    cargarGuardia();
    cargarCapacitacion();
    cargarCategoria();
    cargarEmpresaCapacitacion();
    cargarEntrenador();
    buscarCapacitaciones(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  Future<void> cargarGuardia() async {
    isLoadingGuardia.value = true;
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
    } finally {
      isLoadingGuardia.value = false;
    }
  }

  Future<void> cargarCapacitacion() async {
    isLoadingCapacitacion.value = true;
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(7);

      if (response.success && response.data != null) {
        capacitacionOpciones.assignAll(response.data!);

        log('Capacitacion opciones cargadas correctamente: $capacitacionOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de capacitaciones maestro: $e');
    } finally {
      isLoadingCapacitacion.value = false;
    }
  }

  Future<void> cargarCategoria() async {
    isLoadingCategoria.value = true;
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(9);

      if (response.success && response.data != null) {
        categoriaOpciones.assignAll(response.data!);

        log('Capacitacion opciones cargadas correctamente: $categoriaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de capacitaciones maestro: $e');
    } finally {
      isLoadingCategoria.value = false;
    }
  }

  Future<void> cargarEmpresaCapacitacion() async {
    isLoadingEmpresaCapacitacion.value = true;
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(8);

      if (response.success && response.data != null) {
        empresaCapacitacionOpciones.assignAll(response.data!);

        log('Empresa Capacitacion opciones cargadas correctamente: $empresaCapacitacionOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de empresa capacitaciones maestro: $e');
    } finally {
      isLoadingEmpresaCapacitacion.value = false;
    }
  }

  Future<void> cargarEntrenador() async {
    isLoadingEntrenador.value = true;
    try {
      var response = await personalService.listarEntrenadores();

      if (response.success && response.data != null) {
        entrenadorOpciones.assignAll(response.data!);

        log('Entrenadores opciones cargadas correctamente: $entrenadorOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de entrenador: $e');
    } finally {
      isLoadingEntrenador.value = false;
    }
  }

  Future<void> buscarCapacitaciones(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? numeroDocumento = numeroDocumentoController.text.isEmpty
        ? null
        : numeroDocumentoController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    String? apellidoPaterno = apellidoPaternoController.text.isEmpty
        ? null
        : apellidoPaternoController.text;
    String? apellidoMaterno = apellidoMaternoController.text.isEmpty
        ? null
        : apellidoMaternoController.text;
    try {
      var response = await capacitacionService.CapacitacionConsultaPaginado(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        inGuardia: selectedGuardiaKey.value,
        nombres: nombres,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        inCapacitacion: selectedCapacitacionKey.value,
        inCategoria: selectedCategoriaKey.value,
        inEmpresaCapacitacion: selectedEmpresaCapacitacionKey.value,
        inEntrenador: selectedEntrenadorKey.value,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente $result');

          var items = result['Items'] as List<CapacitacionConsulta>;
          log('Items obtenidos: $items');

          capacitacionResultados.assignAll(items);

          currentPage.value = result['PageNumber'] as int;
          totalPages.value = result['TotalPages'] as int;
          totalRecords.value = result['TotalRecords'] as int;
          rowsPerPage.value = result['PageSize'] as int;
          isExpanded.value = false;

          log('Resultados obtenidos: ${capacitacionResultados.length}');
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

  void clearFields() {
    codigoMcpController.clear();
    numeroDocumentoController.clear();
    selectedGuardiaKey.value = null;
    nombresController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    selectedCapacitacionKey.value = null;
    selectedCategoriaKey.value = null;
    selectedEmpresaCapacitacionKey.value = null;
    selectedEntrenadorKey.value = null;
    rangoFechaController.clear();
    fechaInicio = null;
    fechaTermino = null;
  }
}
