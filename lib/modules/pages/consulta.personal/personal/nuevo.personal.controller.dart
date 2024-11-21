import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/modules/pages/consulta.personal/consulta.personal.controller.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';
import 'package:sgem/shared/widgets/save/widget.save.personal.confirmation.dart';

class NuevoPersonalController extends GetxController {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController puestoTrabajoController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController gerenciaController = TextEditingController();
  final TextEditingController fechaIngresoController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController categoriaLicenciaController =
      TextEditingController();
  final TextEditingController codigoLicenciaController =
      TextEditingController();
  final TextEditingController fechaIngresoMinaController =
      TextEditingController();
  final TextEditingController fechaRevalidacionController =
      TextEditingController();
  final TextEditingController restriccionesController = TextEditingController();

  final PersonalService personalService = PersonalService();

  final PersonalSearchController personalSearchController =
      Get.find<PersonalSearchController>();

  Personal? personalData;
  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();
  RxInt estadoPersonalKey = 0.obs;
  RxString estadoPersonalNombre = ''.obs;
  RxBool isOperacionMina = false.obs;
  RxBool isZonaPlataforma = false.obs;

  //var documentoAdjuntoNombre = ''.obs;
  //var documentoAdjuntoBytes = Rxn<Uint8List>();
  var archivosAdjuntos = <Map<String, dynamic>>[].obs;

  DateTime? fechaIngreso;
  DateTime? fechaIngresoMina;
  DateTime? fechaRevalidacion;

  final ArchivoService archivoService = ArchivoService();

  RxBool isLoadingDni = false.obs;
  RxBool isSaving = false.obs;
  List<String> errores = [];
  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  final maestroDetalleService = MaestroDetalleService();

  Future<void> loadPersonalPhoto(int idOrigen) async {
    personalPhoto.value = null;
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

  Future<void> buscarPersonalPorDni(String dni) async {
    if (dni.isEmpty) {
      _mostrarErroresValidacion(Get.context!, ['Ingrese un DNI válido.']);
      resetControllers();
      return;
    }
    try {
      isLoadingDni.value = true;
      final responseListar = await personalService.listarPersonalEntrenamiento(
        numeroDocumento: dni,
      );

      if (responseListar.success &&
          responseListar.data != null &&
          responseListar.data!.isNotEmpty) {
        _mostrarErroresValidacion(Get.context!,
            ['La persona ya se encuentra registrada en el sistema.']);
        resetControllers();
        return;
      }

      final responseBuscar = await personalService.buscarPersonalPorDni(dni);
      Personal personalData1 = responseBuscar.data!;
      if (personalData1.estado!.key == 96) {
        _mostrarErroresValidacion(
            Get.context!, ['La persona se encuentra cesada.']);
        resetControllers();
        return;
      }
      if (responseBuscar.success && responseBuscar.data != null) {
        personalData = responseBuscar.data;
        llenarControladores(personalData!);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Personal no encontrado.'),
            backgroundColor: Colors.red,
          ),
        );
        resetControllers();
      }
    } catch (e) {
      log('Error inesperado al buscar el personal: $e');
    } finally {
      isLoadingDni.value = false;
    }
  }

  DateTime? parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(rawDate);
    } catch (e) {
      log('Error al parsear la fecha: $e');
      return null;
    }
  }

  void llenarControladores(Personal personalData) {
    loadPersonalPhoto(personalData.inPersonalOrigen!);
    dniController.text = personalData.numeroDocumento ?? '';
    nombresController.text =
        '${personalData.primerNombre ?? ''} ${personalData.segundoNombre ?? ''}';
    puestoTrabajoController.text = personalData.cargo ?? '';
    codigoController.text = personalData.codigoMcp ?? '';
    apellidoPaternoController.text = personalData.apellidoPaterno ?? '';
    apellidoMaternoController.text = personalData.apellidoMaterno ?? '';
    gerenciaController.text = personalData.gerencia ?? '';
    areaController.text = personalData.area ?? '';
    categoriaLicenciaController.text = personalData.licenciaCategoria ?? '';
    codigoLicenciaController.text = personalData.licenciaConducir ?? '';
    restriccionesController.text = personalData.restricciones ?? '';
    fechaIngreso = personalData.fechaIngreso;
    fechaIngresoController.text = fechaIngreso != null
        ? DateFormat('dd/MM/yyyy').format(fechaIngreso!)
        : '';

    fechaIngresoMina = personalData.fechaIngresoMina;
    fechaIngresoMinaController.text = fechaIngresoMina != null
        ? DateFormat('dd/MM/yyyy').format(fechaIngresoMina!)
        : '';

    fechaRevalidacion = personalData.licenciaVencimiento;
    fechaRevalidacionController.text = fechaRevalidacion != null
        ? DateFormat('dd/MM/yyyy').format(fechaRevalidacion!)
        : '';

    if (personalData.guardia != null && personalData.guardia!.key != 0) {
      dropdownController.selectValueKey('guardia', personalData.guardia!.key);
    } else {
      dropdownController.selectValueKey('guardia', null);
    }
    isOperacionMina.value = personalData.operacionMina == 'S';
    isZonaPlataforma.value = personalData.zonaPlataforma == 'S';
    estadoPersonalKey.value = personalData.estado?.key ?? 0;
    estadoPersonalNombre.value = personalData.estado?.nombre ?? 'Sin estado';
    obtenerArchivosRegistrados(1, personalData.key!);
  }

  Future<bool> gestionarPersona({
    required String accion,
    String? motivoEliminacion,
    required BuildContext context,
  }) async {
    errores.clear();
    log('Gestionando persona con la acción: $accion');
    bool esValido = validate(context);
    if (!esValido && accion != 'eliminar') {
      _mostrarErroresValidacion(context, errores);
      return false;
    }
    try {
      isSaving.value = true;
      String obtenerPrimerNombre(String nombres) {
        List<String> nombresSplit = nombres.split(' ');
        return nombresSplit.isNotEmpty ? nombresSplit.first : '';
      }

      String obtenerSegundoNombre(String nombres) {
        List<String> nombresSplit = nombres.split(' ');
        return nombresSplit.length > 1 ? nombresSplit[1] : '';
      }

      String verificarTexto(String texto) {
        return texto.isNotEmpty ? texto : '';
      }

      personalData!
        ..primerNombre = obtenerPrimerNombre(nombresController.text)
        ..segundoNombre = obtenerSegundoNombre(nombresController.text)
        ..apellidoPaterno = verificarTexto(apellidoPaternoController.text)
        ..apellidoMaterno = verificarTexto(apellidoMaternoController.text)
        ..cargo = verificarTexto(puestoTrabajoController.text)
        ..fechaIngreso = fechaIngreso
        ..licenciaConducir = verificarTexto(codigoLicenciaController.text)
        ..fechaIngresoMina = fechaIngresoMina
        ..licenciaVencimiento = fechaRevalidacion
        ..guardia = OptionValue(
          key: dropdownController.getSelectedValue('guardia')?.key ?? 0,
          nombre: personalData!.guardia?.nombre,
        )
        ..operacionMina = isOperacionMina.value ? 'S' : 'N'
        ..zonaPlataforma = isZonaPlataforma.value ? 'S' : 'N'
        ..restricciones = verificarTexto(restriccionesController.text);

      if (accion == 'eliminar') {
        personalData!
          ..eliminado = 'S'
          ..motivoElimina = motivoEliminacion ?? 'Sin motivo'
          ..usuarioElimina = 'usuarioActual';
      }

      final response = await _accionPersona(accion);

      if (response.success) {
        await registrarArchivos(dniController.text);
        if (accion == 'registrar' || accion == 'actualizar') {
          _mostrarMensajeGuardado(Get.context!);
          resetControllers();
          personalSearchController.searchPersonal();
        }
        return true;
      } else {
        log('Acción $accion fallida: ${response.message}');
        return false;
      }
    } catch (e) {
      log('Error al $accion persona: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<ResponseHandler<bool>> _accionPersona(String accion) async {
    log('Personal: ${personalData.toString()}');
    switch (accion) {
      case 'registrar':
        log('Registrar');
        return personalService.registrarPersona(personalData!);
      case 'actualizar':
        log('Actualizar');
        return personalService.actualizarPersona(personalData!);
      case 'eliminar':
        log('Eliminar');
        return personalService.eliminarPersona(personalData!);
      default:
        throw Exception('Acción no reconocida: $accion');
    }
  }

  //Validaciones
  bool validate(BuildContext context) {
    log('Validando la fecha de ingreso a mina');
    log('Fecha de ingreso mina: $fechaIngresoMina');
    if (fechaIngresoMina == null) {
      errores.add('Debe seleccionar una fecha de ingreso a la mina.');
    } else {
      if (fechaIngresoMina!.isBefore(DateTime.now())) {
        log('Fecha de ingreso mina: $fechaIngresoMina');
        errores.add(
            'La fecha de ingreso a la mina debe ser mayor a la fecha actual.');
      }
    }
    if (codigoLicenciaController.text.isEmpty ||
        codigoLicenciaController.text.length != 9) {
      errores
          .add('El código de licencia debe tener 9 caracteres alfanuméricos.');
    }
    if (dropdownController.getSelectedValue('guardia')?.nombre == null) {
      errores.add('Debe seleccionar una guardia.');
    }
    if (restriccionesController.text.length > 100) {
      errores
          .add('El campo de restricciones no debe exceder los 100 caracteres.');
    }
    if (errores.isNotEmpty) {
      return false;
    }
    return true;
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

  void removerArchivo(String nombreArchivo) {
    archivosAdjuntos.removeWhere((archivo) =>
        archivo['nombre'] == nombreArchivo && archivo['nuevo'] == true);
    log('Archivo $nombreArchivo eliminado');
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

  Future<void> obtenerArchivosRegistrados(int idOrigen, int idOrigenKey) async {
    try {
      final response = await archivoService.obtenerArchivosPorOrigen(
        idOrigen: idOrigen, // 1: TABLA Personal
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

  Future<void> eliminarArchivo(Map<String, dynamic> archivo) async {
    try {
      final response = await archivoService.eliminarArchivo(
        key: archivo['key'],
        nombre: archivo['nombre'],
        extension: archivo['extension'],
        mime: archivo['mime'],
        datos: archivo['datos'],
        inTipoArchivo: 1,
        inOrigen: 1,
        inOrigenKey: archivo['inOrigenKey'],
      );

      if (response.success) {
        obtenerArchivosRegistrados(1, archivo['inOrigenKey']);
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

  void resetControllers() {
    dniController.clear();
    nombresController.clear();
    puestoTrabajoController.clear();
    codigoController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    gerenciaController.clear();
    fechaIngresoController.clear();
    areaController.clear();
    categoriaLicenciaController.clear();
    codigoLicenciaController.clear();
    fechaIngresoMinaController.clear();
    fechaRevalidacionController.clear();
    restriccionesController.clear();
    personalPhoto.value = null;
    isOperacionMina.value = false;
    isZonaPlataforma.value = false;
    estadoPersonalKey.value = 0;
    estadoPersonalNombre.value = '';
    //documentoAdjuntoNombre.value = '';
    //documentoAdjuntoBytes.value = null;
    personalData = null;
    dropdownController.resetAllSelections();
  }
}
