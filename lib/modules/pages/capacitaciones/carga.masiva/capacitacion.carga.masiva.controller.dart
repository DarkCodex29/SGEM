import 'dart:developer';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/modules/capacitacion.carga.masiva.resultado.dart';

class CapacitacionCargaMasivaController extends GetxController {
  TextEditingController archivoController = TextEditingController();

  var cargaMasivaResultados = <CapacitacionCargaMasivaResultado>[].obs;
  var cargaMasivaResultadosPaginados = <CapacitacionCargaMasivaResultado>[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  Future<void> cargarArchivo() async {
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
          for (var i = 1; i < rows.length; i++) {
            // Ignorar la primera fila (cabecera)
            var row = rows[i];
            cargaMasivaResultados
                .add(CapacitacionCargaMasivaResultado.fromExcelRow(row));
          }
          log('Archivo Excel cargado con éxito');
          totalRecords.value = cargaMasivaResultados.length;
          totalPages.value = (totalRecords.value / rowsPerPage.value).ceil();
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  void previsualizarCarga() {
    totalRecords.value = cargaMasivaResultados.length;
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