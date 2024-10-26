import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CapacitacionCargaMasivaController extends GetxController{
TextEditingController archivoController = TextEditingController();

var cargaMasivaResultados= [].obs;
var rowsPerPage = 10.obs;
var currentPage = 1.obs;
var totalPages = 1.obs;
var totalRecords = 0.obs;

Future<void> cargarArchivo() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.bytes != null) {
          Uint8List fileBytes = file.bytes!;
          String fileName = file.name;

          // archivosAdjuntos.add({
          //   'nombre': fileName,
          //   'bytes': fileBytes,
          //   'nuevo': true,
          // });
          archivoController.text= fileName;
          log('Documento adjuntado correctamente: $fileName');
        }
      }
    } else {
      log('No se seleccionaron archivos');
    }
  } catch (e) {
    log('Error al adjuntar documentos: $e');
  }
}
}