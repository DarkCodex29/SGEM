import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/shared/modules/capacitacion.carga.masiva.validado.dart';

import '../../../../shared/modules/capacitacion.carga.masiva.excel.dart';

class CapacitacionCargaMasivaController extends GetxController {
  TextEditingController archivoController = TextEditingController();

  var cargaMasivaResultados = <CapacitacionCargaMasivaExcel>[].obs;
  var cargaMasivaResultadosValidados = <CapacitacionCargaMasivaValidado>[].obs;
  var cargaMasivaResultadosPaginados = <CapacitacionCargaMasivaExcel>[].obs;
  var registrosConErrores = <Map<String, dynamic>>[].obs;
  var capacitacionService = CapacitacionService();
  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;
  var correctRecords = 0.obs;

  var errorRecords = 0.obs;

  Future<void> cargarArchivo() async {
    cargaMasivaResultadosValidados.clear();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          Uint8List fileBytes = file.bytes!;
          String fileName = file.name;

          archivoController.text = fileName; // Muestra el nombre del archivo
          log('Documento adjuntado correctamente: $fileName');

          // Leer el archivo Excel
          var excel = Excel.decodeBytes(fileBytes);
          var sheet = excel.tables.keys.first;
          var rows = excel.tables[sheet]?.rows ?? [];

          // Procesar datos de Excel
          cargaMasivaResultados.clear();
          registrosConErrores.clear();

          for (var i = 1; i < rows.length; i++) {
            // Ignorar la primera fila (cabecera)
            var row = rows[i];
            var registro = CapacitacionCargaMasivaExcel.fromExcelRow(row);
            // cargaMasivaResultados
            //     .add(CapacitacionCargaMasivaResultado.fromExcelRow(row));

            // registro = validarRegistro(registro);

            cargaMasivaResultados.add(registro);
          }

          log('Archivo Excel cargado con éxito');
          totalRecords.value = cargaMasivaResultados.length;
          totalPages.value = (totalRecords.value / rowsPerPage.value).ceil();

          correctRecords.value = cargaMasivaResultados.length;
          errorRecords.value = registrosConErrores.length;

          goToPage(1);
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  Future<void> previsualizarCarga() async {
    if (cargaMasivaResultados.isNotEmpty) {
      final response = await capacitacionService.validarCargaMasiva(
        cargaMasivaList: cargaMasivaResultados,
      );
      if (response.success) {
        cargaMasivaResultadosValidados.value = response.data!;
      }
    } else {
      // Mostrar mensaje de error cuando no hay archivo seleccionado
      Get.snackbar(
        'Error',
        'No se ha seleccionado ningún archivo para cargar.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }

    // totalRecords.value = cargaMasivaResultados.length;
  }


  void goToPage(int page) {
    currentPage.value = page;
    int start = (currentPage.value - 1) * rowsPerPage.value;
    int end = start + rowsPerPage.value;

    // Actualiza los resultados paginados
    cargaMasivaResultadosPaginados.value = cargaMasivaResultados.sublist(
        start, end.clamp(0, cargaMasivaResultados.length));
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      goToPage(currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      goToPage(currentPage.value - 1);
    }
  }
}
