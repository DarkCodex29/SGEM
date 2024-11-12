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
import 'package:sgem/modules/pages/capacitaciones/capacitacion.controller.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';
import 'package:sgem/shared/widgets/save/widget.save.personal.confirmation.dart';

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
  DateTime? fechaInicio;
  DateTime? fechaTermino;
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

  final List<String> errores = [];

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  // MODELOS
  EntrenamientoModulo? entrenamientoModulo;
  Personal? personalInterno;
  Personal? personalExterno;
  String tipoPersona = '';

  CapacitacionController capacitacionController =
      Get.put(CapacitacionController());

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
        personalExterno = response.data!;
        log('PersonalExterno: ${personalExterno!.toJson()}');

        nombresController.text =
            '${personalExterno!.primerNombre} ${personalExterno!.segundoNombre}';
        apellidoPaternoController.text = personalExterno!.apellidoPaterno!;
        apellidoMaternoController.text = personalExterno!.apellidoMaterno!;

        log('Personal externo cargado con éxito: ${personalExterno!.nombreCompleto}');
      } else {
        log('No se encontró personal externo con el DNI proporcionado');
        Get.snackbar(
            'Error', 'No se encontró personal externo con el DNI proporcionado',
            backgroundColor: Colors.red, colorText: Colors.white);
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
      nombresController.text =
          '${personalExterno!.primerNombre} ${personalExterno!.segundoNombre}';
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

  Future<bool?> registrarCapacitacion() async {
    try {
      // Validar que exista el personal interno
      if (personalInterno?.key == null) {
        Get.snackbar('Error', 'No se ha seleccionado personal interno',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // Validar campos requeridos
      if (!_validarCamposRequeridos()) {
        Get.snackbar('Error', 'Por favor complete todos los campos requeridos',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // Validar fechas
      if (fechaInicio == null || fechaTermino == null) {
        Get.snackbar('Error', 'Las fechas son requeridas',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // Crear el modelo de capacitación
      entrenamientoModulo = EntrenamientoModulo()
        ..inTipoActividad = TipoActividad.CAPACITACION
        ..inCapacitacion = 25
        ..inModulo = 0
        ..modulo = OptionValue(key: 0, nombre: '')
        ..tipoPersona = tipoPersona.isEmpty ? 'I' : tipoPersona
        ..inPersona = personalInterno!.key
        ..inActividadEntrenamiento = personalInterno!.key
        ..inCategoria =
            dropdownController.getSelectedValue('categoria')?.key ?? 0
        ..inEquipo = 0
        ..equipo = OptionValue(key: 0, nombre: '')
        ..inEntrenador =
            dropdownController.getSelectedValue('entrenador')?.key ?? 0
        ..entrenador = OptionValue(
            key: dropdownController.getSelectedValue('entrenador')?.key ?? 0,
            nombre:
                dropdownController.getSelectedValue('entrenador')?.nombre ?? '')
        ..inEmpresaCapacitadora =
            dropdownController.getSelectedValue('empresaCapacitacion')?.key ?? 0
        ..inCondicion = 0
        ..condicion = OptionValue(key: 0, nombre: '')
        ..inEstado = 0
        ..estadoEntrenamiento = OptionValue(key: 0, nombre: '')
        ..fechaInicio = fechaInicio
        ..fechaTermino = fechaTermino;

      // Manejo seguro de conversiones numéricas
      try {
        entrenamientoModulo!
          ..inTotalHoras = int.parse(horasController.text)
          ..inNotaTeorica = int.parse(notaTeoriaController.text)
          ..inNotaPractica = int.parse(notaPracticaController.text);
      } catch (e) {
        log('Error al convertir valores numéricos: $e');
        Get.snackbar(
            'Error', 'Los valores de horas y notas deben ser números válidos',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // Validar que las notas estén en el rango correcto (0-99)
      if (!_validarRangoNotas()) {
        Get.snackbar('Error', 'Las notas deben estar entre 0 y 99',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      log('Enviando datos de registro: ${entrenamientoModulo!.toJson()}');

      final response =
          await capacitacionService.registrarCapacitacion(entrenamientoModulo!);

      if (response.success) {
        log('Capacitación registrada exitosamente');
        _mostrarMensajeGuardado(Get.context!);
        capacitacionController.buscarCapacitaciones(
            pageNumber: capacitacionController.currentPage.value,
            pageSize: capacitacionController.rowsPerPage.value);
        return true;
      } else {
        log('Error al registrar la capacitación: ${response.message}');
        Get.snackbar('Error',
            'No se pudo registrar la capacitación: ${response.message}',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      log('Error al registrar la capacitación: $e');
      Get.snackbar(
          'Error', 'Ocurrió un error inesperado al registrar la capacitación',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<bool?> actualizarCapacitacion() async {
    if (entrenamientoModulo == null) {
      log('Error: entrenamientoModulo es null');
      return false;
    }

    try {
      // Validar campos requeridos
      if (!_validarCamposRequeridos()) {
        log('Error: campos requeridos incompletos');
        Get.snackbar('Error', 'Por favor complete todos los campos requeridos',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      // Crear una copia del modelo para actualizarlo
      final capacitacionActualizada = EntrenamientoModulo()
        ..key = entrenamientoModulo!.key
        ..inTipoActividad = TipoActividad.CAPACITACION
        ..inCapacitacion = 25
        ..inModulo = 0
        ..modulo = OptionValue(key: 0, nombre: '')
        ..tipoPersona = tipoPersona.isEmpty ? 'I' : tipoPersona
        ..inPersona = personalInterno!.key
        ..inActividadEntrenamiento = personalInterno!.key
        ..inCategoria = dropdownController.getSelectedValue('categoria')?.key
        ..inEquipo = 0
        ..equipo = OptionValue(key: 0, nombre: '')
        ..inEntrenador = dropdownController.getSelectedValue('entrenador')?.key
        ..entrenador = OptionValue(
            key: dropdownController.getSelectedValue('entrenador')?.key ?? 0,
            nombre:
                dropdownController.getSelectedValue('entrenador')?.nombre ?? '')
        ..inEmpresaCapacitadora =
            dropdownController.getSelectedValue('empresaCapacitacion')?.key
        ..inCondicion = 0
        ..condicion = OptionValue(key: 0, nombre: '')
        ..inEstado = 0
        ..estadoEntrenamiento = OptionValue(key: 0, nombre: '')
        ..fechaInicio = _parseFecha(fechaInicioController.text)
        ..fechaTermino = _parseFecha(fechaTerminoController.text)
        ..inTotalHoras = int.tryParse(horasController.text) ?? 0
        ..inNotaTeorica = int.tryParse(notaTeoriaController.text) ?? 0
        ..inNotaPractica = int.tryParse(notaPracticaController.text) ?? 0;

      log('Enviando actualización: ${capacitacionActualizada.toJson()}');

      final response = await capacitacionService
          .actualizarCapacitacion(capacitacionActualizada);

      if (response.success) {
        log('Capacitación actualizada exitosamente');
        _mostrarMensajeGuardado(Get.context!);
        return true;
      } else {
        log('Error en la respuesta del servidor: ${response.message}');
        Get.snackbar('Error',
            'No se pudo actualizar la capacitación: ${response.message}',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      log('Error al actualizar la capacitación: $e');
      Get.snackbar('Error', 'Ocurrió un error al actualizar la capacitación',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  DateTime? _parseFecha(String fecha) {
    try {
      return DateFormat('dd/MM/yyyy').parse(fecha);
    } catch (e) {
      log('Error al parsear fecha: $e');
      return null;
    }
  }

  bool _validarRangoNotas() {
    try {
      final notaTeorica = int.parse(notaTeoriaController.text);
      final notaPractica = int.parse(notaPracticaController.text);

      return notaTeorica >= 0 &&
          notaTeorica <= 99 &&
          notaPractica >= 0 &&
          notaPractica <= 99;
    } catch (e) {
      return false;
    }
  }

  bool _validarCamposRequeridos() {
    return fechaInicioController.text.isNotEmpty &&
        fechaTerminoController.text.isNotEmpty &&
        horasController.text.isNotEmpty &&
        notaTeoriaController.text.isNotEmpty &&
        notaPracticaController.text.isNotEmpty &&
        dropdownController.getSelectedValue('categoria') != null &&
        dropdownController.getSelectedValue('entrenador') != null &&
        dropdownController.getSelectedValue('empresaCapacitacion') != null;
  }

  void _mostrarMensajeGuardado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MensajeGuardadoWidget();
      },
    );
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
