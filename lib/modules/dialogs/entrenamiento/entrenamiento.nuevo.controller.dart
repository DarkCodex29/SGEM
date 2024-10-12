import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/Repository/DTO/MaestroDetaille.dart';
import 'package:sgem/config/Repository/MainRespository.dart';
import 'package:sgem/config/api/api.training.dart';
import 'package:sgem/modules/pages/personal.training/personal.training.controller.dart';
import 'package:sgem/modules/pages/personal.training/training/training.personal.controller.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/training.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';

class EntrenamientoNuevoController extends GetxController {
  TextEditingController fechaInicioEntrenamiento = TextEditingController();
  TextEditingController fechaTerminoEntrenamiento = TextEditingController();
  PersonalSearchController personalSearchController =
      PersonalSearchController();
  TrainingPersonalController controllerPersonal =
      Get.put(TrainingPersonalController());
  RxList<MaestroDetalle> equipoDetalle = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> condicionDetalle = <MaestroDetalle>[].obs;

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

  final trainingService = TrainingService();

  var isLoading = false.obs;
  var documentoAdjuntoNombre = ''.obs;

  var documentoAdjuntoBytes = Rxn<Uint8List>();

  var repository = MainRepository();

  @override
  void onInit() {
    super.onInit();
    getEquiposAndConditions();
  }

  Future<void> getEquiposAndConditions() async {
    try {
      isLoading.value = true;

      await Future.wait([getEquipos(), getCondiciones()]);
      log('Datos de equipos y condiciones cargados correctamente');
    } catch (e) {
      log('Error al cargar equipos o condiciones: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getEquipos() async {
    try {
      final List<MaestroDetalle>? equipos = await repository
          .listarMaestroDetallePorMaestro(MaestroDetalleTypes.equipo.rawValue);

      if (equipos != null) {
        log("Equipos cargados: ${equipos.toString()}");
        equipoDetalle.assignAll(equipos);
      } else {
        log("No se cargaron equipos");
      }
    } catch (e) {
      log('Error al cargar equipos: $e');
    }
  }

  Future<void> getCondiciones() async {
    try {
      final List<MaestroDetalle>? condiciones =
          await repository.listarMaestroDetallePorMaestro(
              MaestroDetalleTypes.condition.rawValue);

      if (condiciones != null) {
        log("Condiciones cargadas: ${condiciones.toString()}");
        condicionDetalle.assignAll(condiciones);
      } else {
        log("No se cargaron condiciones");
      }
    } catch (e) {
      log('Error al cargar condiciones: $e');
    }
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

  DateTime transformDate(String date) {
    // Formato dd/MM/yyyy
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    return dateTime;
  }

  DateTime transformDateFormat(String date, String format) {
    // Formato dd/MM/yyyy
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

  void registertraining(Entrenamiento register, Function(bool) callback) async {
    try {
      isLoading.value = true;
      final response = await trainingService.registerTraining(register);
      if (response.success && response.data != null) {
        print('Registrar entrenamiento exitoso: ${response.data}');
        controllerPersonal.fetchTrainings(register.inPersona);
        callback(true);
      } else {
        print('Error al registrar entrenamiento: ${response.message}');
        callback(false);
      }
    } catch (e) {
      print('CATCH: Error al registrar entrenamiento: $e');
      callback(false);
    } finally {
      isLoading.value = false;
    }
  }
}
