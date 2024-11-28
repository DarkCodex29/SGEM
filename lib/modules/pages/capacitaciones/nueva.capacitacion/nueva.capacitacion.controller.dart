import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/constants/origen.archivo.dart';
import 'package:sgem/config/constants/tipo.actividad.dart';
import 'package:sgem/modules/pages/capacitaciones/capacitacion.controller.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';
import 'package:sgem/shared/widgets/save/widget.save.personal.confirmation.dart';

class NuevaCapacitacionController extends GetxController {
  // Controladores de campos de texto
  final TextEditingController codigoMcpController = TextEditingController();
  final TextEditingController dniInternoController = TextEditingController();
  final TextEditingController dniExternoController = TextEditingController();
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

  CapacitacionController capacitacionController =
      Get.find<CapacitacionController>();

  void _mostrarMensajeGuardado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MensajeGuardadoWidget();
      },
    );
  }

  void _mostrarErroresValidacion(BuildContext context, List<String> errores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }

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

  Future<Personal?> loadPersonalInterno(String codigoMcp, bool validate) async {
    if (codigoMcp.isEmpty && validate) {
      _mostrarErroresValidacion(
          Get.context!, ['Por favor ingrese un código MCP']);
      return null;
    }
    try {
      final response = await personalService.listarPersonalEntrenamiento(
          codigoMcp: codigoMcp);
      if (response.success && response.data != null) {
        personalInterno = response.data!.first;
        llenarControladores();
      } else {
        _mostrarErroresValidacion(
            Get.context!, ['No se encontró personal con ese código MCP.']);
      }
    } catch (e) {
      _mostrarErroresValidacion(
          Get.context!, ['No se encontró personal con ese código MCP.']);
    }
    return null;
  }

  Future<Personal?> loadPersonalExterno(String dni, bool validate) async {
    if (dni.isEmpty && validate) {
      _mostrarErroresValidacion(
          Get.context!, ['Por favor ingrese un número de documento.']);
      return null;
    }
    try {
      final response =
          await personalService.obtenerPersonalExternoPorNumeroDocumento(dni);

      if (response.success && response.data != null) {
        personalExterno = response.data;
        llenarControladores();
      } else {
        _mostrarErroresValidacion(Get.context!,
            ['No se encontró personal con ese número de documento.']);
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
      dropdownController.selectValueKey(
          'capacitacion', entrenamientoModulo!.inCapacitacion);
    }

    if (isInternoSelected == true) {
      loadPersonalPhoto(personalInterno!.inPersonalOrigen!);
      codigoMcpController.text = personalInterno!.codigoMcp!;
      dniInternoController.text = personalInterno!.numeroDocumento!;
      nombresController.text = personalInterno!.nombreCompleto!;
      apellidoPaternoController.text = personalInterno!.apellidoPaterno!;
      apellidoMaternoController.text = personalInterno!.apellidoMaterno!;
      guardiaController.text = personalInterno!.guardia!.nombre!;
    }

    if (isInternoSelected == false) {
      loadPersonalPhoto(personalExterno!.inPersonalOrigen!);
      nombresController.text =
          '${personalExterno!.primerNombre} ${personalExterno!.segundoNombre}';
      dniExternoController.text = personalExterno!.numeroDocumento!;
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
      if (!_validarHoras()) {
        return false;
      }

      if (!_validarFechas()) {
        return false;
      }

      // Validar que exista el personal interno
      if (isInternoSelected == true && personalInterno == null) {
        _mostrarErroresValidacion(
            Get.context!, ['Por favor busque un personal']);
        return false;
      }

      if (isInternoSelected == false && personalExterno == null) {
        _mostrarErroresValidacion(
            Get.context!, ['Por favor busque un externo']);
        return false;
      }

      // Validar campos requeridos
      if (!_validarCamposRequeridos()) {
        _mostrarErroresValidacion(
            Get.context!, ['Por favor complete todos los campos requeridos.']);
        return false;
      }

      // Validar fechas
      if (fechaInicio == null || fechaTermino == null) {
        _mostrarErroresValidacion(
            Get.context!, ['Por favor ingrese fechas válidas.']);
        return false;
      }

      // Crear el modelo de capacitación
      entrenamientoModulo = EntrenamientoModulo()
        ..inTipoActividad = TipoActividad.CAPACITACION
        ..inCapacitacion =
            dropdownController.getSelectedValue('capacitacion')?.key ?? 0
        ..inModulo = 0
        ..modulo = OptionValue(key: 0, nombre: '')
        ..tipoPersona = isInternoSelected == true ? 'I' : 'E'
        ..inPersona = isInternoSelected == true
            ? personalInterno!.key
            : personalExterno!.inPersonalOrigen!
        ..inActividadEntrenamiento = 0
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
        _mostrarErroresValidacion(Get.context!, [
          'Los valores de horas y notas deben ser números válidos',
        ]);
        return false;
      }

      // Validar que las notas estén en el rango correcto (0-99)
      if (!_validarRangoNotas()) {
        _mostrarErroresValidacion(Get.context!, [
          'Las notas deben estar entre 0 y 99',
        ]);
        return false;
      }

      log('Enviando datos de registro: ${entrenamientoModulo!.toJson()}');

      final response =
          await capacitacionService.registrarCapacitacion(entrenamientoModulo!);
      log('Response: ${response.data}');
      if (response.success) {
        await registrarArchivos(isInternoSelected == true
            ? personalInterno!.numeroDocumento!
            : personalExterno!.numeroDocumento!);
        log('Capacitación registrada exitosamente');
        _mostrarMensajeGuardado(Get.context!);
        capacitacionController.clearFields();
        capacitacionController.buscarCapacitaciones();
        return true;
      } else {
        log('Error al registrar la capacitación: ${response.message}');
        Get.snackbar('Error',
            'No se pudo registrar la capacitación: ${response.message}',
            backgroundColor: Colors.red,
            colorText: const Color.fromARGB(255, 250, 128, 128));
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
        _mostrarErroresValidacion(Get.context!, [
          'Por favor complete todos los campos requeridos',
        ]);
        return false;
      }

      if (!_validarHoras()) {
        return false;
      }

      if (!_validarFechas()) {
        return false;
      }

      // Crear una copia del modelo para actualizarlo
      final capacitacionActualizada = EntrenamientoModulo()
        ..key = entrenamientoModulo!.key
        ..inTipoActividad = TipoActividad.CAPACITACION
        ..inCapacitacion =
            dropdownController.getSelectedValue('capacitacion')?.key ?? 0
        ..inModulo = 0
        ..modulo = OptionValue(key: 0, nombre: '')
        ..tipoPersona = isInternoSelected == true ? 'I' : 'E'
        ..inPersona = isInternoSelected == true
            ? personalInterno!.key
            : personalExterno!.inPersonalOrigen!
        ..inActividadEntrenamiento = 0
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
        ..fechaInicio = fechaInicio
        ..fechaTermino = fechaTermino;

      try {
        entrenamientoModulo!
          ..inTotalHoras = int.parse(horasController.text)
          ..inNotaTeorica = int.parse(notaTeoriaController.text)
          ..inNotaPractica = int.parse(notaPracticaController.text);
      } catch (e) {
        _mostrarErroresValidacion(Get.context!, [
          'Los valores de horas y notas deben ser números válidos',
        ]);
        return false;
      }

      if (!_validarRangoNotas()) {
        _mostrarErroresValidacion(Get.context!, [
          'Las notas deben estar entre 0 y 99',
        ]);
        return false;
      }

      log('Enviando actualización: ${capacitacionActualizada.toJson()}');

      final response = await capacitacionService
          .actualizarCapacitacion(capacitacionActualizada);

      if (response.success) {
        await registrarArchivos(isInternoSelected == true
            ? personalInterno!.numeroDocumento!
            : personalExterno!.numeroDocumento!);
        log('Capacitación actualizada exitosamente');
        _mostrarMensajeGuardado(Get.context!);
        capacitacionController.clearFields();
        capacitacionController.buscarCapacitaciones();
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

  bool _validarFechas() {
    if (fechaInicio == null || fechaTermino == null) {
      _mostrarErroresValidacion(
          Get.context!, ['Por favor ingrese fechas válidas.']);
      return false;
    }

    if (fechaTermino!.isBefore(fechaInicio!)) {
      _mostrarErroresValidacion(Get.context!,
          ['La fecha de término debe ser mayor o igual a la fecha de inicio.']);
      return false;
    }

    return true;
  }

  bool _validarHoras() {
    final horasText = horasController.text.trim();

    if (horasText.isEmpty) {
      _mostrarErroresValidacion(
          Get.context!, ['El campo de horas es obligatorio']);
      return false;
    }

    if (!RegExp(r'^\d+$').hasMatch(horasText)) {
      _mostrarErroresValidacion(
          Get.context!, ['El campo de horas debe contener solo números']);
      return false;
    }

    if (horasText.length > 3) {
      _mostrarErroresValidacion(Get.context!,
          ['El campo de horas no puede exceder los 3 caracteres']);
      return false;
    }

    return true;
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
              inTipoArchivo: OrigenArchivo.capacitacion,
              inOrigen: TipoActividad.CAPACITACION,
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

  Future<void> obtenerArchivosRegistrados(int idOrigen, int idOrigenKey) async {
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
            'key': archivo['Key'],
            'nombre': archivo['Nombre'],
            'extension': archivo['Extension'],
            'mime': archivo['Mime'],
            'datos': base64Encode(archivoBytes),
            'inOrigenKey': idOrigenKey,
            'nuevo': false,
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

  void removerArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    log('Archivo $nombreArchivo eliminado');
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

  Future<void> eliminarArchivo(Map<String, dynamic> archivo) async {
    try {
      final response = await archivoService.eliminarArchivo(
        key: archivo['key'],
        nombre: archivo['nombre'],
        extension: archivo['extension'],
        mime: archivo['mime'],
        datos: archivo['datos'],
        inTipoArchivo: OrigenArchivo.capacitacion,
        inOrigen: TipoActividad.CAPACITACION,
        inOrigenKey: archivo['inOrigenKey'],
      );

      if (response.success) {
        obtenerArchivosRegistrados(
            OrigenArchivo.capacitacion, archivo['inOrigenKey']);
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
      log('Error al eliminar el archivo: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void resetControllers() {
    personalPhoto.value = null;
    codigoMcpController.clear();
    dniInternoController.clear();
    dniExternoController.clear();
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
    archivosAdjuntos.clear();
  }
}
