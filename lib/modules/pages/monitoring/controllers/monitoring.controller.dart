import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/config/api/api.monitoring.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/monitoring.detail.dart';
import 'package:sgem/shared/modules/monitoring.save.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/functions/parse.date.time.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/save/widget.save.personal.confirmation.dart';

class CreateMonitoringController extends GetxController {
  final EntrenamientoService entrenamientoService = EntrenamientoService();
  final monitoringService = MonitoringService();
  final PersonalService personalService = PersonalService();
  final codigoMCPController = TextEditingController();
  final codigoMCP2Controller = TextEditingController();
  final fullNameController = TextEditingController();
  final guardController = TextEditingController();
  final stateTrainingController = TextEditingController();
  final moduleController = TextEditingController();
  final commentController = TextEditingController();
  DateTime? fechaProximoMonitoreoController;
  DateTime? fechaRealMonitoreoController;
  final horasController = TextEditingController();
  final modelMonitoring = MonitoingSave(
      inTipoActividad: 0,
      inTipoPersona: 0,
      //inPersona: selectedPersonKey.value,
      inPersona: 0,
      inEquipo: 0,
      inEntrenador: 0,
      inCondicion: 0,
      inTotalHoras: 0,
      estadoEntrenamiento: OptionValue());

  RxBool isLoadingCodeMcp = false.obs;
  RxBool isSaving = false.obs;
  RxBool isLoandingSave = false.obs;
  RxBool isLoandingDetail = false.obs;
  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();

  var selectedEquipoKey = RxnInt();
  var selectedEntrenadorKey = RxnInt();
  var selectedModuloKey = RxnInt();
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoEntrenamientoKey = RxnInt();
  var selectedCondicionKey = RxnInt();
  var selectedPersonKey = RxnInt();
  final ArchivoService archivoService = ArchivoService();
  var documentoAdjuntoNombre = ''.obs;
  var documentoAdjuntoBytes = Rxn<Uint8List>();
  var archivosAdjuntos = <Map<String, dynamic>>[].obs;

  clearModel() {
    modelMonitoring ==
        MonitoingSave(
          inTipoActividad: 0,
          inTipoPersona: 0,
          //inPersona: selectedPersonKey.value,
          inPersona: 0,
          inEquipo: 0,
          inEntrenador: 0,
          inCondicion: 0,
          inTotalHoras: 0,
          estadoEntrenamiento: OptionValue(),
        );
    selectedPersonKey.value = null;
    selectedEquipoKey.value = null;
    selectedEntrenadorKey.value = null;
    selectedCondicionKey.value = null;
    selectedEstadoEntrenamientoKey.value = null;
    fechaProximoMonitoreoController = null;
    fechaRealMonitoreoController = null;
    horasController.text = "";
    modelMonitoring.key = null;
    codigoMCP2Controller.text = "";
    codigoMCPController.text = "";
    fullNameController.text = "";
    guardController.text = "";
    stateTrainingController.text = "";
    moduleController.text = "";
    selectedPersonKey.value = null;
    personalPhoto.value = null;
  }

  Future<bool> saveMonitoring(BuildContext context) async {
    bool state = false;
    try {
      if (selectedPersonKey.value == null) {
        mostrarErroresValidacion(
            Get.context!, ['No hay información de la persona']);
        return false;
      }
      if (selectedEquipoKey.value == null) {
        mostrarErroresValidacion(
            Get.context!, ['Por favor seleccione  el equipo']);
        return false;
      }
      if (selectedEntrenadorKey.value == null) {
        mostrarErroresValidacion(
            Get.context!, ['Por favor seleccione el  entrenador']);
        return false;
      }
      if (selectedCondicionKey.value == null) {
        mostrarErroresValidacion(
            Get.context!, ['Por favor seleccione la condición']);
        return false;
      }
      if (selectedEstadoEntrenamientoKey.value == null) {
        mostrarErroresValidacion(
            Get.context!, ['Por favor seleccione el estado del entrenamiento']);
        return false;
      }
      modelMonitoring.inPersona = selectedPersonKey.value;
      modelMonitoring.inEquipo = selectedEquipoKey.value;
      modelMonitoring.inEntrenador = selectedEntrenadorKey.value;
      modelMonitoring.inCondicion = selectedCondicionKey.value;
      modelMonitoring.estadoEntrenamiento =
          OptionValue(key: selectedEstadoEntrenamientoKey.value, nombre: "");
      modelMonitoring.fechaProximoMonitoreo = fechaProximoMonitoreoController;
      modelMonitoring.fechaRealMonitoreo = fechaRealMonitoreoController;
      modelMonitoring.inTotalHoras = int.parse(horasController.text);
      modelMonitoring.comentarios = commentController.text;
      ResponseHandler<bool> response;
      if (modelMonitoring.key == null || modelMonitoring.key == 0) {
        response = await monitoringService.registerMonitoring(modelMonitoring);
      } else {
        response = await monitoringService.updateMonitoring(modelMonitoring);
      }
      if (response.success) {
        // ignore: use_build_context_synchronously
        _mostrarMensajeGuardado(context);
        state = true;
      } else {
        mostrarErroresValidacion(Get.context!, ['Error al guardar monitoreo']);
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoandingSave.value = false;
    }
    return state;
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

  Future<void> uploadArchive() async {
    final archivosNuevos =
        archivosAdjuntos.where((archivo) => archivo['nuevo'] == true).toList();
    for (final archivo in archivosNuevos) {
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
          inOrigen: 1, // 1: TABLA Personal
          inOrigenKey: modelMonitoring.key!,
        );

        if (response.success) {
          log('Archivo ${archivo['nombre']} registrado con éxito');
          archivo['nuevo'] = false;
        } else {
          log('Error al registrar archivo ${archivo['nombre']}: ${response.message}');
        }
      } catch (e) {
        log('Error al registrar archivo ${archivo['nombre']}: $e');
      }
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

  Future<void> obtenerArchivosRegistrados(int idOrigen, int idOrigenKey) async {
    log('Obteniendo archivos registrados');
    log('idOrigen: $idOrigen, idOrigenKey: $idOrigenKey');
    try {
      final response = await archivoService.obtenerArchivosPorOrigen(
        idOrigen: idOrigen,
        idOrigenKey: idOrigenKey,
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
    }
  }

  void eliminarArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    log('Archivo $nombreArchivo eliminado');
  }

  Future<void> descargarArchivo(Map<String, dynamic> archivo) async {
    try {
      String nombreArchivo = archivo['nombre'];
      Uint8List archivoBytes = archivo['bytes'];
      String extension = nombreArchivo.split('.').last;
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

      Get.snackbar(
        'Descarga exitosa',
        'El archivo $nombreArchivo.$extension se descargó correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log('Error al descargar el archivo $e');
      Get.snackbar(
        'Error',
        'No se pudo descargar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  Future<bool> deleteMonitoring(BuildContext context) async {
    bool state = false;
    try {
      final response =
          await monitoringService.deleteMonitoring(modelMonitoring);
      if (response.success) {
        _mostrarMensajeGuardado(
          // ignore: use_build_context_synchronously
          context,
          title: "Monitoreo Eliminado",
        );
        state = true;
        clearModel();
      } else {
        mostrarErroresValidacion(
            Get.context!, ['Error al Eliminar monitoreo']);
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoandingSave.value = false;
    }
    return state;
  }

  Future<void> searchPersonByCodeMcp() async {
    if (codigoMCPController.text.isEmpty) {
      mostrarErroresValidacion(
          Get.context!, ['Ingrese un Código MCP válido.']);
      resetInfoPerson();
      return;
    }
    try {
      isLoadingCodeMcp.value = true;
      final responseListar = await personalService.listarPersonalEntrenamiento(
        codigoMcp: codigoMCPController.text,
      );
      if ((responseListar.data == null || responseListar.data!.isEmpty)) {
        mostrarErroresValidacion(Get.context!,
            ['El personal no se encuentra registrado en el sistema.']);
      }
      setInfoPerson(responseListar.data!.first);
      await loadPersonalPhoto(responseListar.data!.first.inPersonalOrigen!);
    } catch (e) {
      log('Error inesperado al buscar el personal: $e');
    } finally {
      isLoadingCodeMcp.value = false;
    }
  }

  Future<void> fetchTrainings(int personId) async {
    try {
      log("Entrenamiento Controller: $personId");
      final response =
          await entrenamientoService.listarEntrenamientoPorPersona(personId);
      if (response.success) {
        final trainingList = response.data!
            .map((json) => EntrenamientoModulo.fromJson(json))
            .toList();
        for (var training in trainingList) {
          await _fetchAndCombineUltimoModulo(training);
        }
      } else {
        Get.snackbar('Error', 'No se pudieron cargar los entrenamientos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar los entrenamientos');
    }
  }

  Future<void> _fetchAndCombineUltimoModulo(
      EntrenamientoModulo training) async {
    try {
      final response = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(training.key!);
      if (response.success && response.data != null) {
        EntrenamientoModulo ultimoModulo = response.data!;
        training.actualizarConUltimoModulo(ultimoModulo);
        stateTrainingController.text =
            training.estadoEntrenamiento!.nombre ?? "";
        moduleController.text = training.modulo!.nombre ?? "";
      } else {
        log('Error al obtener el último módulo: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener el último módulo: $e');
    }
  }

  Future<void> loadPersonalPhoto(int idOrigen) async {
    try {
      final photoResponse =
          await personalService.obtenerFotoPorCodigoOrigen(idOrigen);

      if (photoResponse.success && photoResponse.data != null) {
        personalPhoto.value = photoResponse.data;
      } else {
        log('Error al cargar la foto: ${photoResponse.message}');
      }
    } catch (e) {
      log('Error al cargar la foto del personal: $e');
    }
  }

  Future<void> searchMonitoringDetailById(int key) async {
    try {
      isLoandingDetail.value = true;
      final result = await monitoringService.searchMonitoringDetailById(key);
      final monitoring = MonitoringDetail.fromJson(result);
      selectedPersonKey.value = monitoring.inPersona;
      selectedEquipoKey.value = monitoring.equipo?.key;
      selectedEntrenadorKey.value = monitoring.entrenador?.key;
      selectedCondicionKey.value = monitoring.condicion?.key;
      selectedEstadoEntrenamientoKey.value =
          monitoring.estadoEntrenamiento?.key;
      fechaProximoMonitoreoController =
          FnDateTime.fromDotNetDate(monitoring.fechaProximoMonitoreo ?? "");
      fechaRealMonitoreoController =
          FnDateTime.fromDotNetDate(monitoring.fechaRealMonitoreo ?? "");
      horasController.text = monitoring.inTotalHoras.toString();
      modelMonitoring.key = monitoring.key;
      commentController.text = monitoring.comentarios ?? "";
      final personalInfo = await personalService
          .buscarPersonalPorId(monitoring.inPersona!.toString());
      final person = Personal.fromJson(personalInfo);
      codigoMCPController.text = person.codigoMcp!;
      await searchPersonByCodeMcp();
      isLoandingDetail.value = false;
      obtenerArchivosRegistrados(1, monitoring.key!);
      codigoMCP2Controller.text = person.codigoMcp!;
    } catch (e) {
      log('error al obtener la información del monitoreo');
    }
  }

  setInfoPerson(Personal person) {
    codigoMCP2Controller.text = person.codigoMcp!;
    fullNameController.text =
        "${person.apellidoPaterno} ${person.apellidoMaterno} ${person.segundoNombre}";
    guardController.text = person.guardia!.nombre!;
    stateTrainingController.text = "";
    moduleController.text = "";
    selectedPersonKey.value = person.key;
    fetchTrainings(person.id);
  }

  resetInfoPerson() {
    codigoMCP2Controller.text = "";
    fullNameController.text = "";
    guardController.text = "";
    stateTrainingController.text = "";
    moduleController.text = "";
  }

  void _mostrarMensajeGuardado(BuildContext context,
      {String title = "Los datos se guardaron \nsatisfactoriamente"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeGuardadoWidget(
          title: title,
        );
      },
    );
  }

  void mostrarErroresValidacion(BuildContext context, List<String> errores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }
}
