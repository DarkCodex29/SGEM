import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../shared/modules/cronograma.detail.dart';

class CronogramaFechasController extends GetxController {
  final RxList<CronogramaDetalle> result = <CronogramaDetalle>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    search();
  }

  void clearFilter() {
    result.clear();
    search();
  }

  void search() {
    isLoading.value = true;
    // Aquí deberías asignar datos reales en lugar de los datos ficticios
    result.assignAll(fakeCronogramaData);
    isLoading.value = false;
  }

  Future<void> downloadExcel() async {
    try {
      final excel = Excel.createExcel();
      // Renombrar la hoja predeterminada "Sheet1" a "Entrenamiento"
      excel.rename('Sheet1', 'Entrenamiento');
      final sheet = excel['Entrenamiento']; 

      // Agregar cabeceras
      List<String> headers = [
        'Año',
        'Guardia',
        'Fecha Inicio',
        'Fecha Fin',
        'Usuario Registro',
        'Fecha Registro',
      ];
      for (int i = 0; i < headers.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);  
      }

      // Agregar datos
      for (int rowIndex = 0; rowIndex < result.length; rowIndex++) {
        var item = result[rowIndex];
        List<dynamic> rowValues = [
          item.anio.toString(),
          item.guardia ?? '',
          DateFormat('dd/MM/yyyy').format(item.fechaInicio),
          DateFormat('dd/MM/yyyy').format(item.fechaFin),
          item.usuarioRegistro ?? '',
          DateFormat('dd/MM/yyyy HH:mm:ss').format(item.fechaRegistro),
        ];

        for (int colIndex = 0; colIndex < rowValues.length; colIndex++) {
          var cell = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex + 1));
          cell.value = TextCellValue(rowValues[colIndex].toString()); 
        }
      }

      // Convertir a bytes y guardar el archivo
      final excelBytes = excel.encode();
      if (excelBytes != null) {
        final Uint8List uint8ListBytes = Uint8List.fromList(excelBytes);
        final String fileName = 'Cronograma_${DateTime.now().millisecondsSinceEpoch}.xlsx';

        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: uint8ListBytes,
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        Get.snackbar('Éxito', 'Archivo Excel descargado correctamente');
      }
    } catch (e) {
      log('Error al generar Excel: $e');
      Get.snackbar('Error', 'No se pudo descargar el archivo');
    }
  }

}
