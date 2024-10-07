import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/Repository/DTO/MaestroDetaille.dart';
import 'package:sgem/config/Repository/MainRespository.dart';
import 'package:sgem/config/api/api.trining.dart';
import 'package:sgem/modules/pages/personal.training/personal.training.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/registrar.training.dart';

class RegisterTrainingController extends GetxController {

  TextEditingController fechaInicioEntrenamiento = TextEditingController();
  TextEditingController fechaTerminoEntrenamiento = TextEditingController();
  PersonalSearchController personalSearchController = PersonalSearchController();
  RxList<MaestroDetalle> equipoDetalle = <MaestroDetalle>[].obs;
  
  MaestroDetalle? equipoSelected;

  final trainingService = TriningService();

  var isLoading = false.obs;
  var documentoAdjuntoNombre = ''.obs;
  
  var documentoAdjuntoBytes = Rxn<Uint8List>();

  var repository = MainRepository();
  
  @override
  void onInit() {
    getEquipos();
    super.onInit();
  }
  
  void getEquipos() {
    isLoading.value = true;
     repository.listarMaestroDetallePorMaestro(MaestroDetalleTypes.equipo.rawValue, (p0) {
      if (p0 != null) {
        equipoDetalle.assignAll(p0);
      }
      isLoading.value = false;
    });
  }


  void eliminarDocumento() {
    documentoAdjuntoNombre.value = '';
    documentoAdjuntoBytes.value = null;
    log('Documento eliminado');
  }

  void adjuntarDocumento() async {
    try {
      final resultado = await seleccionarArchivo();

      if (resultado != null) {
        documentoAdjuntoNombre.value = resultado['nombre'];
        documentoAdjuntoBytes.value = resultado['bytes'];
        log('Documento adjuntado correctamente: ${documentoAdjuntoNombre.value}');
      } else {
        log('No se seleccionó ningún archivo');
      }
    } catch (e) {
      log('Error al adjuntar documento: $e');
    }
  }

  DateTime transformDate(String date) {// Formato dd/MM/yyyy
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    return dateTime;
  }

  DateTime transformDateFormat(String date, String format) {// Formato dd/MM/yyyy
    DateTime dateTime = DateFormat(format).parse(date);
    return dateTime;
  }

  Future<Map<String, dynamic>?> seleccionarArchivo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name;
        return {
          'nombre': fileName,
          'bytes': fileBytes,
        };
      }
    } catch (e) {
      log('Error al seleccionar el archivo: $e');
      return null;
    }
    return null;
  }
    
  void registertraining(RegisterTraining register) async {
    print('func: registertraining');
    try{
      isLoading.value = true;
      final response = await trainingService.registerTraining(register);
      isLoading.value = false;
      if(response.success && response.data != null) {
        print('Registrar entrenamiento exitoso: ${response.data}');
      } else {
        print('Error al registrar entrenamiento: ${response.message}');
      }
    } catch (e) {
      isLoading.value = false;
      print('CATCH: Error al registrar entrenamiento: $e');
    }
  }
  

}