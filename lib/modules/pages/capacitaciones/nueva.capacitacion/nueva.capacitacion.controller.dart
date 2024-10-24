import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
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
  RxnString categoriaSeleccionada = RxnString();
  RxnString empresaSeleccionada = RxnString();
  RxnString entrenadorSeleccionado = RxnString();
  RxnString nombreCapacitacionSeleccionada = RxnString();

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

  // Listas de opciones
  var empresaOpciones = ['Empresa A', 'Empresa B', 'Empresa C'].obs;
  var entrenadorOpciones = ['Entrenador 1', 'Entrenador 2', 'Entrenador 3'].obs;
  var nombreCapacitacion = ['Nombre 1', 'Nombre 2', 'Nombre 3'].obs;

  // Función para alternar entre Personal Interno y Externo
  void seleccionarInterno() => isInternoSelected.value = true;
  void seleccionarExterno() => isInternoSelected.value = false;

  final maestroDetalleService = MaestroDetalleService();

  RxBool isLoadingCategoria = false.obs;

  var selectedCategoriaKey = RxnInt();

  RxList<MaestroDetalle> categoriaOpciones = <MaestroDetalle>[].obs;

  final GenericDropdownController<MaestroDetalle> dropdownController =
      Get.put(GenericDropdownController<MaestroDetalle>());
  final GenericDropdownController<Personal> personalDropdownController =
      Get.put(GenericDropdownController<Personal>());
  @override
  void onInit() {
    //cargarCategoria();
    cargarDropdowns();
    super.onInit();
  }

  void cargarDropdowns() {
    dropdownController.loadOptions('guardia', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('categoria', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(9);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('empresaCapacitacion', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(8);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('capacitacion', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(7);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });
    
    personalDropdownController.loadOptions('entrenador', () async {
      var response = await personalService.listarEntrenadores();
      return response.success && response.data != null
          ? response.data!
          : <Personal>[];
    });
  }

/*
  Future<void> cargarCategoria() async {
    isLoadingCategoria.value = true;
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(9);

      if (response.success && response.data != null) {
        categoriaOpciones.assignAll(response.data!);

        log('Capacitacion opciones cargadas correctamente: $categoriaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de capacitaciones maestro: $e');
    } finally {
      isLoadingCategoria.value = false;
    }
  }
*/
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

  Future<void> registrarCapacitacion(EntrenamientoModulo capacitacion) async {
    try {
      final response = await capacitacionService.registrarModulo(capacitacion);
      if (response.success) {
        log('Capacitación registrada con éxito');
      } else {
        log('Error al registrar la capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al registrar la capacitación: $e');
    }
  }

  Future<void> actualizarCapacitacion(EntrenamientoModulo capacitacion) async {
    try {
      final response = await capacitacionService.actualizarModulo(capacitacion);
      if (response.success) {
        log('Capacitación actualizada con éxito');
      } else {
        log('Error al actualizar la capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al actualizar la capacitación: $e');
    }
  }

  Future<void> eliminarCapacitacion(EntrenamientoModulo capacitacion) async {
    try {
      final response = await capacitacionService.eliminarModulo(capacitacion);
      if (response.success) {
        log('Capacitación eliminada con éxito');
      } else {
        log('Error al eliminar la capacitación: ${response.message}');
      }
    } catch (e) {
      log('Error al eliminar la capacitación: $e');
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
        int origenKey = personalResponse.data!.first.key;
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
              inOrigen: 1, // 1: TABLA Personal
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

  @override
  void onClose() {
    codigoMcpController.dispose();
    dniController.dispose();
    nombresController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    fechaInicioController.dispose();
    fechaTerminoController.dispose();
    horasController.dispose();
    notaTeoriaController.dispose();
    notaPracticaController.dispose();
    super.onClose();
  }
}
