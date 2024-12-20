import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/Repository/DTO/MaestroDetaille.dart';
import 'package:sgem/config/Repository/MainRespository.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/constants/tipo.archivo.entrenamiento.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/utils/Extensions/format_extension.dart';
import 'package:sgem/shared/utils/Extensions/get_snackbar.dart';
import 'package:sgem/shared/widgets/dropDown/custom.dropdown.global.dart';
import '../../entrenamiento.personal.controller.dart';

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


  final _logger = Logger('EntrenamientoNuevoController');

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

  //var documentoAdjuntoNombre = ''.obs;
  //var documentoAdjuntoBytes = Rxn<Uint8List>();
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

      _logger.info('Datos de equipos y condiciones cargados correctamente');
    } catch (e) {
      _logger.info('Error al cargar equipos o condiciones: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void removerArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    //documentoAdjuntoNombre.value = '';
  }

  Future<void> eliminarArchivo(Map<String, dynamic> archivo) async {
    try {
      final response = await archivoService.eliminarArchivo(
        key: archivo['key'],
        nombre: archivo['nombre'],
        extension: archivo['extension'],
        mime: archivo['mime'],
        datos: archivo['datos'],
        inTipoArchivo: 1,
        inOrigen: 2,
        inOrigenKey: archivo['inOrigenKey'],
      );

      if (response.success) {
        obtenerArchivosRegistrados(2, archivo['inOrigenKey']);
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el archivo: ${response.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.info('Error al eliminar el archivo: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
            //documentoAdjuntoNombre.value = fileName;
            _logger.info('Documento adjuntado correctamente: $fileName');
          }
        }
      } else {
        _logger.info('No se seleccionaron archivos');
      }
    } catch (e) {
      _logger.info('Error al adjuntar documentos: $e');
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
            inTipoArchivo: TipoArchivoEntrenamiento.OTROS,
            inOrigen: 2, // TABLA Entrenamiento
            inOrigenKey: inOrigenKey,
          );
          if (response.success) {
            archivo['nuevo'] = false;
          }
        } catch (e) {
          _logger.info('Error al registrar archivo ${archivo['nombre']}: $e');
        }
      }
    } catch (e) {
      _logger.info('Error al registrar archivos: $e');
    }
  }

  Future<void> descargarArchivo(Map<String, dynamic> archivo) async {
    try {
      String nombreArchivo = archivo['nombre'];
      String extension = archivo['extension'];
      String datosBase64 = archivo['datos'];
      Uint8List archivoBytes = base64Decode(datosBase64);

      if (nombreArchivo.endsWith('.$extension')) {
        nombreArchivo = nombreArchivo.substring(
            0, nombreArchivo.length - extension.length - 1);
      }
      MimeType mimeType = _determinarMimeType2(extension);
      await FileSaver.instance.saveFile(
        name: nombreArchivo,
        bytes: archivoBytes,
        ext: extension,
        mimeType: mimeType,
      );
    } catch (e) {
      _logger.info('Error al descargar el archivo $e');
      Get.snackbar(
        'Error',
        'No se pudo descargar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> obtenerArchivosRegistrados(int idOrigen, int inOrigenKey) async {
    try {
      isLoadingFiles.value = true;
      final response = await archivoService.obtenerArchivosPorOrigen(
        idOrigen: idOrigen, // 2: TABLA Entrenamiento
        idOrigenKey: inOrigenKey,
      );
      _logger.info('Response: ${response.data}');
      if (response.success && response.data != null) {
        archivosAdjuntos.clear();
        for (var archivo in response.data!) {
          List<int> datos = List<int>.from(archivo['Datos']);
          Uint8List archivoBytes = Uint8List.fromList(datos);

          archivosAdjuntos.add({
            'key': archivo['Key'],
            'nombre': archivo['Nombre'],
            'extension': archivo['Extension'],
            'mime': archivo['Mime'],
            'datos': base64Encode(archivoBytes),
            'inOrigenKey': inOrigenKey,
            'nuevo': false,
          });
          _logger.info('Archivo ${archivo['Nombre']} obtenido con éxito');
        }
      } else {
        _logger.info('Error al obtener archivos: ${response.message}');
      }
    } catch (e) {
      _logger.info('Error al obtener archivos: $e');
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

  MimeType _determinarMimeType2(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return MimeType.pdf;
      case 'doc':
      case 'docx':
        return MimeType.microsoftWord;
      case 'xlsx':
        return MimeType.microsoftExcel;
      default:
        return MimeType.other;
    }
  }

  void registertraining(
      EntrenamientoModulo register, Function(bool) callback) async {
    _logger.info('Registrando entrenamiento: ${register.toJson()}');
    try {
      isLoading.value = true;
      final response = await trainingService.registerTraining(register);
      if (response.success && response.data != null) {
        controllerPersonal.fetchTrainings(register.inPersona!);
        callback(true);
      } else {
        _logger.info('Error al registrar entrenamiento: ${response.message}');
        callback(false);
      }
    } catch (e) {
      _logger.info('CATCH: Error al registrar entrenamiento: $e');
      callback(false);
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    fechaInicioController.clear();
    fechaTerminoController.clear();
    observacionesEntrenamiento.clear();
    equipoSelected.value = null;
    condicionSelected.value = null;
    estadoEntrenamientoSelected.value = null;
    archivosAdjuntos.clear();
  }

  void completeFields(EntrenamientoModulo entrenamiento) {
    if (equipoDetalle.isEmpty) {
      Get.errorSnackbar('No se han cargado los datos de los equipos');
      return;
    }
    equipoSelected.value =
        equipoDetalle.firstWhereOrNull((e) => e.key == entrenamiento.inEquipo);
    condicionSelected.value = condicionDetalle
        .firstWhereOrNull((e) => e.key == entrenamiento.inCondicion);
    estadoEntrenamientoSelected.value = estadoDetalle.firstWhereOrNull(
        (e) => e.key == entrenamiento.estadoEntrenamiento?.key);
    // estadoEntrenamientoSelected.value =
    //     estadoDetalle.firstWhereOrNull((e) => e.key == entrenamiento.inEstado);

    fechaInicioController.text = entrenamiento.fechaInicio?.format ?? '';
    fechaTerminoController.text = entrenamiento.fechaTermino?.format ?? '';

    observacionesEntrenamiento.text = entrenamiento.comentarios ?? '';
    obtenerArchivosRegistrados(2, entrenamiento.key!);
  }
}
