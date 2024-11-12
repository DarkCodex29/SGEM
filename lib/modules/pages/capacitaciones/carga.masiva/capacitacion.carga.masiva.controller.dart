import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/shared/modules/capacitacion.carga.masiva.validado.dart';

import '../../../../shared/modules/capacitacion.carga.masiva.excel.dart';

class CapacitacionCargaMasivaController extends GetxController {
  TextEditingController archivoController = TextEditingController();

  var cargaMasivaExcel = <CapacitacionCargaMasivaExcel>[].obs;
  var cargaMasivaResultadosValidados = <CapacitacionCargaMasivaValidado>[].obs;
  var cargaMasivaResultadosPaginados = <CapacitacionCargaMasivaValidado>[].obs;
  var registrosConErrores = <Map<String, dynamic>>[].obs;
  var capacitacionService = CapacitacionService();
  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;
  var correctRecords = 0.obs;

  var errorRecords = 0.obs;

  var archivoSeleccionado = false.obs; // Estado de archivo seleccionado
  var registrosValidados = false.obs; // Estado de validación de registros
  var sinErrores = false.obs; // Estado de errores en registros

  Future<void> cargarArchivo() async {
    cargaMasivaResultadosPaginados.clear();
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
          cargaMasivaExcel.clear();
          registrosConErrores.clear();
          log('Cantidad de registros excel: ${rows.length}');
          for (var i = 1; i < rows.length; i++) {
            // Ignorar la primera fila (cabecera)
            var row = rows[i];
            var registro = CapacitacionCargaMasivaExcel.fromExcelRow(row);
            log('Fecha inicio: ${registro.fechaInicio}');

            cargaMasivaExcel.add(registro);
          }

          log('Archivo Excel cargado con éxito');
          archivoSeleccionado.value = true;
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  Future<void> previsualizarCarga() async {
    if (cargaMasivaExcel.isNotEmpty) {
      // Muestra el mensaje de espera
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Evita cerrar el diálogo
      );

      final response = await capacitacionService.validarCargaMasiva(
        cargaMasivaList: cargaMasivaExcel,
      );
      if (response.success) {
        cargaMasivaResultadosValidados.value = response.data!;

        Get.back();
        goToPage(1);

        totalRecords.value = cargaMasivaResultadosValidados.length;
        totalPages.value = (totalRecords.value / rowsPerPage.value).ceil();

        // Contar los registros correctos y con errores
        int correctCount = 0;
        int errorCount = 0;

        for (var record in cargaMasivaResultadosValidados) {
          if (record.esValido) {
            correctCount++;
          } else {
            errorCount++;
          }
        }

        correctRecords.value = correctCount;
        errorRecords.value = errorCount;

        registrosValidados.value = true;
        if (errorRecords.value == 0) {
          sinErrores.value = true;
        }
      }
    } else {
      // Mostrar mensaje de error cuando no hay archivo seleccionado
      Get.snackbar(
        'Error',
        'No se ha seleccionado ningún archivo para cargar.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        isDismissible: true,
      );
    }

    // totalRecords.value = cargaMasivaResultados.length;
  }
  bool esConfirmacionValida() {
    return archivoSeleccionado.value && registrosValidados.value && sinErrores.value;
  }
  Future<void> descargarPlantilla() async {
    try {
      ByteData data = await rootBundle.load('assets/excel/Plantilla.xlsx');
      Uint8List bytes = data.buffer.asUint8List();
      String fileName = 'Plantilla';
      await FileSaver.instance.saveFile(
          name: fileName,
          bytes: bytes,
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel);

      Get.snackbar('Descarga exitosa', 'Plantilla descargada con éxito',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,);
    } catch (e) {
      Get.snackbar('Error', 'Error al descargar la plantilla',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    int start = (currentPage.value - 1) * rowsPerPage.value;
    int end = start + rowsPerPage.value;

    // Actualiza los resultados paginados
    cargaMasivaResultadosPaginados.value = cargaMasivaResultadosValidados
        .sublist(start, end.clamp(0, cargaMasivaResultadosValidados.length));
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
