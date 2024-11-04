import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/constants/tipo.actividad.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class NuevaCapacitacionController extends GetxController {
  // Controladores de campos de texto
  final TextEditingController codigoMcpController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaTerminoController = TextEditingController();
  final TextEditingController horasController = TextEditingController();
  final TextEditingController notaTeoriaController = TextEditingController();
  final TextEditingController notaPracticaController = TextEditingController();
  final TextEditingController guardiaController = TextEditingController();

  // Variables de selección
  RxBool isInternoSelected = true.obs;

  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();
  final PersonalService personalService = PersonalService();
  var selectedPersonal = Rxn<Personal>();

  //ARCHIVOS
  var documentoAdjuntoNombre = ''.obs;
  var documentoAdjuntoBytes = Rxn<Uint8List>();
  var archivosAdjuntos = <Map<String, dynamic>>[].obs;
  final ArchivoService archivoService = ArchivoService();

  // capacitacion service
  final CapacitacionService capacitacionService = CapacitacionService();

  // Función para alternar entre Personal Interno y Externo
  void seleccionarInterno() => isInternoSelected.value = true;
  void seleccionarExterno() => isInternoSelected.value = false;

  final maestroDetalleService = MaestroDetalleService();

  RxBool isLoadingCategoria = false.obs;

  RxList<MaestroDetalle> categoriaOpciones = <MaestroDetalle>[].obs;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  // MODELOS
  EntrenamientoModulo? entrenamientoModulo;
  Personal? personalInterno;
  Personal? personalExterno;
  String tipoPersona = '';

  Future<EntrenamientoModulo?> loadCapacitacion(int capacitacionKey) async {
    try {
      final response =
          await capacitacionService.obtenerCapacitacionPorId(capacitacionKey);
      if (response.success && response.data != null) {
        entrenamientoModulo = response.data;
        llenarControladores();
      } else {
        log('Error al obtener datos de capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al cargar capacitación: $e');
    }
    return null;
  }

  Future<Personal?> loadPersonalInterno(String codigoMcp) async {
    try {
      final response = await personalService.listarPersonalEntrenamiento(
          codigoMcp: codigoMcp);
      if (response.success && response.data != null) {
        personalInterno = response.data!.first;
        llenarControladores();
      } else {
        log('Error al obtener datos de personal: ${response.message}');
      }
    } catch (e) {
      log('Error al cargar personal: $e');
    }
    return null;
  }

  Future<void> buscarPersonalExternoPorDni(String dni) async {
    try {
      final response =
          await personalService.obtenerPersonalExternoPorNumeroDocumento(dni);

      if (response.success && response.data != null) {
        personalExterno = response.data;

        //dniController.text = personalExterno!.numeroDocumento;
        nombresController.text =
            '${personalExterno!.primerNombre} ${personalExterno!.segundoNombre}';
        //guardiaController.text = personalExterno!.guardia.nombre;
        apellidoPaternoController.text = personalExterno!.apellidoPaterno!;
        apellidoMaternoController.text = personalExterno!.apellidoMaterno!;

        //await loadPersonalPhoto(personalExterno!.inPersonalOrigen);

        log('Personal externo cargado con éxito: ${personalExterno!.nombreCompleto}');
      } else {
        log('No se encontró personal externo con el DNI proporcionado');
        Get.snackbar(
            'Error', 'No se encontró personal externo con el DNI proporcionado',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error al buscar personal externo: $e');
      Get.snackbar('Error', 'Error al buscar personal externo: $e');
    }
  }

  Future<Personal?> loadPersonalExterno(String dni) async {
    try {
      final response =
          await personalService.obtenerPersonalExternoPorNumeroDocumento(dni);
      if (response.success && response.data != null) {
        personalExterno = response.data;
        llenarControladores();
      } else {
        log('Error al obtener datos de personal: ${response.message}');
      }
    } catch (e) {
      log('Error al cargar personal externo: $e');
    }
    return null;
  }

  void llenarControladores() {
    resetControllers();
    if (entrenamientoModulo != null) {
      fechaInicioController.text = entrenamientoModulo!.fechaInicio != null
          ? DateFormat('dd/MM/yyyy').format(entrenamientoModulo!.fechaInicio!)
          : '';
      fechaTerminoController.text = entrenamientoModulo!.fechaTermino != null
          ? DateFormat('dd/MM/yyyy').format(entrenamientoModulo!.fechaTermino!)
          : '';
      horasController.text =
          entrenamientoModulo!.inTotalHoras?.toString() ?? '';
      notaTeoriaController.text =
          entrenamientoModulo!.inNotaTeorica?.toString() ?? '';
      notaPracticaController.text =
          entrenamientoModulo!.inNotaPractica?.toString() ?? '';
      dropdownController.selectValueKey(
          'categoria', entrenamientoModulo!.inCategoria);
      dropdownController.selectValueKey(
          'empresaCapacitacion', entrenamientoModulo!.inEmpresaCapacitadora);
      dropdownController.selectValueKey(
          'entrenador', entrenamientoModulo!.inEntrenador);
      dropdownController.selectValueKey('capacitacion', 25);
    }

    if (personalInterno != null) {
      loadPersonalPhoto(personalInterno!.inPersonalOrigen!);
      codigoMcpController.text = personalInterno!.codigoMcp!;
      dniController.text = personalInterno!.numeroDocumento!;
      nombresController.text = personalInterno!.nombreCompleto!;
      apellidoPaternoController.text = personalInterno!.apellidoPaterno!;
      apellidoMaternoController.text = personalInterno!.apellidoMaterno!;
      guardiaController.text = personalInterno!.guardia!.nombre!;
    }

    if (personalExterno != null) {
      loadPersonalPhoto(personalExterno!.inPersonalOrigen!);
      dniController.text = personalExterno!.numeroDocumento!;
      nombresController.text = personalExterno!.nombreCompleto!;
      apellidoPaternoController.text = personalExterno!.apellidoPaterno!;
      apellidoMaternoController.text = personalExterno!.apellidoMaterno!;
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

  Future<void> registrarCapacitacion() async {
    try {
      final response =
          await capacitacionService.registrarCapacitacion(entrenamientoModulo!);
      if (response.success) {
        log('Capacitación registrada con éxito');
      } else {
        log('Error al registrar la capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al registrar la capacitación: $e');
    }
  }

  Future<void> actualizarCapacitacion() async {
    entrenamientoModulo!.inCategoria =
        dropdownController.getSelectedValue('categoria')?.key;
    entrenamientoModulo!.inEmpresaCapacitadora =
        dropdownController.getSelectedValue('empresaCapacitacion')?.key;
    entrenamientoModulo!.inEntrenador =
        dropdownController.getSelectedValue('entrenador')?.key;
    entrenamientoModulo!.fechaInicio =
        DateFormat('dd/MM/yyyy').parse(fechaInicioController.text);
    entrenamientoModulo!.fechaTermino =
        DateFormat('dd/MM/yyyy').parse(fechaTerminoController.text);
    entrenamientoModulo!.inHorasAcumuladas = int.parse(horasController.text);
    entrenamientoModulo!.inCapacitacion = 25;
    entrenamientoModulo!.inNotaTeorica = int.parse(notaTeoriaController.text);
    entrenamientoModulo!.inNotaPractica =
        int.parse(notaPracticaController.text);
    try {
      log('capacitacion: ${entrenamientoModulo!.toJson()}');
      final response = await capacitacionService
          .actualizarCapacitacion(entrenamientoModulo!);
      log('response: ${response.data}');
      if (response.success) {
        log('Capacitación actualizada con éxito');
      } else {
        log('Error al actualizar la capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al actualizar la capacitación: $e');
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

  Future<void> registrarArchivos(String dni) async {
    try {
      final personalResponse = await personalService
          .listarPersonalEntrenamiento(numeroDocumento: dni);

      if (personalResponse.success && personalResponse.data!.isNotEmpty) {
        int origenKey = personalResponse.data!.first.key!;
        log('Key del personal obtenida: $origenKey');
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
              inOrigen: TipoActividad.CAPACITACION, // 1: TABLA Personal
              inOrigenKey: origenKey,
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
      } else {
        log('Error al obtener la key del personal');
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
    }
  }

  String _determinarMimeType(String extension) {
    switch (extension) {
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

  void eliminarArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    log('Archivo $nombreArchivo eliminado');
  }

  void resetControllers() {
    personalPhoto.value = null;
    codigoMcpController.clear();
    dniController.clear();
    nombresController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    fechaInicioController.clear();
    fechaTerminoController.clear();
    horasController.clear();
    notaTeoriaController.clear();
    notaPracticaController.clear();
    guardiaController.clear();
    dropdownController.resetAllSelections();
  }
}
