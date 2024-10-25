import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sgem/config/Repository/DTO/MaestroDetaille.dart';
import 'package:sgem/config/Repository/MainRespository.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/modules/pages/personal.training/entrenamiento/entrenamiento.personal.controller.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.dart';

class EntrenamientoNuevoController extends GetxController {
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaTerminoController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  TextEditingController observacionesEntrenamiento = TextEditingController();

  EntrenamientoPersonalController controllerPersonal =
      Get.put(EntrenamientoPersonalController());
  RxList<MaestroDetalle> equipoDetalle = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> condicionDetalle = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> estadoDetalle = <MaestroDetalle>[].obs;

  var equipoSelected = Rxn<MaestroDetalle?>();
  late final equipoSelectedBinding = Binding(get: () {
    return equipoSelected.value;
  }, set: (DropdownElement? newValue) {
    equipoSelected.value = newValue as MaestroDetalle;
    return;
  });

  var condicionSelected = Rxn<MaestroDetalle?>();
  late final condicionSelectedBinding = Binding(get: () {
    return condicionSelected.value;
  }, set: (DropdownElement? newValue) {
    condicionSelected.value = newValue as MaestroDetalle;
    return;
  });

  var estadoEntrenamientoSelected = Rxn<MaestroDetalle?>();
  late final estadoEntrenamientoSelectedBinding = Binding(get: () {
    return estadoEntrenamientoSelected.value;
  }, set: (DropdownElement? newValue) {
    estadoEntrenamientoSelected.value = newValue as MaestroDetalle;
    return;
  });

  final trainingService = EntrenamientoService();

  final archivoService = ArchivoService();

  var isLoading = false.obs;

  var documentoAdjuntoNombre = ''.obs;
  var documentoAdjuntoBytes = Rxn<Uint8List>();
  var archivosAdjuntos = <Map<String, dynamic>>[].obs;
  var isLoadingFiles = false.obs;

  var repository = MainRepository();

  @override
  void onInit() {
    super.onInit();
    getEquiposAndConditions();
  }

  Future<void> getEquiposAndConditions() async {
    isLoading.value = true;
    try {
      final equiposFuture = repository
          .listarMaestroDetallePorMaestro(MaestroDetalleTypes.equipo.rawValue);
      final condicionesFuture = repository.listarMaestroDetallePorMaestro(
          MaestroDetalleTypes.condicionEntrenamiento.rawValue);
      final estadosEntrenamientoFuture =
          repository.listarMaestroDetallePorMaestro(
              MaestroDetalleTypes.estadoEntrenamiento.rawValue);

      final results = await Future.wait(
          [equiposFuture, condicionesFuture, estadosEntrenamientoFuture]);
      final equipos = results[0];
      final condiciones = results[1];
      final estados = results[2];

      if (equipos != null) equipoDetalle.assignAll(equipos);
      if (condiciones != null) condicionDetalle.assignAll(condiciones);
      if (estados != null) estadoDetalle.assignAll(estados);

      log("Datos de equipos y condiciones cargados correctamente");
    } catch (e) {
      log("Error al cargar equipos o condiciones: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void eliminarArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    documentoAdjuntoNombre.value = '';
    log('Archivo $nombreArchivo eliminado');
  }

  Future<void> adjuntarDocumentos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            Uint8List fileBytes = file.bytes!;
            String fileName = file.name;
            archivosAdjuntos.add({
              'nombre': fileName,
              'bytes': fileBytes,
              'nuevo': true,
            });
            documentoAdjuntoNombre.value = fileName;
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

  Future<void> registrarArchivos(int inOrigenKey) async {
    try {
      var archivosNuevos = archivosAdjuntos
          .where((archivo) => archivo['nuevo'] == true)
          .toList();
      for (var archivo in archivosNuevos) {
        try {
          String datosBase64 = base64Encode(archivo['bytes']);
          String extension = archivo['nombre'].split('.').last;
          String mimeType = _determinarMimeType(extension);
          final response = await archivoService.registrarArchivo(
            key: 0,
            nombre: archivo['nombre'],
            extension: extension,
            mime: mimeType,
            datos: datosBase64,
            inTipoArchivo: 1,
            inOrigen: 2, // TABLA Entrenamiento
            inOrigenKey: inOrigenKey,
          );
          if (response.success) {
            archivo['nuevo'] = false;
          }
        } catch (e) {
          log('Error al registrar archivo ${archivo['nombre']}: $e');
        }
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
    }
  }

  Future<void> obtenerArchivosRegistrados(int inOrigenKey) async {
    log('Obteniendo archivos registrados');
    log('inOrigenKey: $inOrigenKey');
    try {
      isLoadingFiles.value = true;
      final response = await archivoService.obtenerArchivosPorOrigen(
        idOrigen: 2, // TABLA Entrenamiento
        idOrigenKey: inOrigenKey,
      );
      log('Response: ${response.data}');
      if (response.success && response.data != null) {
        archivosAdjuntos.clear();
        for (var archivo in response.data!) {
          List<int> datos = List<int>.from(archivo['Datos']);
          Uint8List archivoBytes = Uint8List.fromList(datos);

          archivosAdjuntos.add({
            'nombre': archivo['Nombre'],
            'bytes': archivoBytes,
          });

          log('Archivo ${archivo['Nombre']} obtenido con éxito');
        }
      } else {
        log('Error al obtener archivos: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener archivos: $e');
    } finally {
      isLoadingFiles.value = false;
    }
  }

  String _determinarMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream';
    }
  }

  void registertraining(
      EntrenamientoModulo register, Function(bool) callback) async {
    log('Registrando entrenamiento: ${register.toJson()}');
    try {
      isLoading.value = true;
      final response = await trainingService.registerTraining(register);
      if (response.success && response.data != null) {
        controllerPersonal.fetchTrainings(register.inPersona!);
        callback(true);
      } else {
        log('Error al registrar entrenamiento: ${response.message}');
        callback(false);
      }
    } catch (e) {
      log('CATCH: Error al registrar entrenamiento: $e');
      callback(false);
    } finally {
      isLoading.value = false;
    }
  }
}
