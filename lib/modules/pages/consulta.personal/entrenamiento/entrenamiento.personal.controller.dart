import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'modales/nuevo.entrenamiento/entrenamiento.nuevo.controller.dart';

class EntrenamientoPersonalController extends GetxController {
  var trainingList = <EntrenamientoModulo>[].obs;
  final EntrenamientoService entrenamientoService = EntrenamientoService();
  final ModuloMaestroService moduloMaestroService = ModuloMaestroService();
  var modulosPorEntrenamiento = <int, RxList<EntrenamientoModulo>>{}.obs;
  var selectedTraining = Rxn<EntrenamientoModulo>();
  var isLoading = false.obs;

  void setSelectedTrainingKey(EntrenamientoModulo? training) {
    selectedTraining.value = training;
  }

  Future<void> fetchTrainings(int personId) async {
    try {
      isLoading.value = true;
      log("Entrenamiento Controller: $personId");
      final response =
          await entrenamientoService.listarEntrenamientoPorPersona(personId);
      if (response.success) {
        trainingList.value = response.data!
            .map((json) => EntrenamientoModulo.fromJson(json))
            .toList();
        for (var training in trainingList) {
          await _fetchAndCombineUltimoModulo(training);
        }
        await _fetchModulosParaEntrenamientos();
      } else {
        Get.snackbar('Error', 'No se pudieron cargar los entrenamientos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar los entrenamientos');
    } finally {
      isLoading.value = false;
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

        trainingList.refresh();
      } else {
        log('Error al obtener el último módulo: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener el último módulo: $e');
    }
  }

  Future<void> _fetchModulosParaEntrenamientos() async {
    for (var entrenamiento in trainingList) {
      try {
        final response = await moduloMaestroService
            .listarModulosPorEntrenamiento(entrenamiento.key!);
        if (response.success) {
          modulosPorEntrenamiento[entrenamiento.key!] =
              RxList<EntrenamientoModulo>(response.data!);
        }
      } catch (e) {
        log('Error al cargar los módulos: $e');
        Get.snackbar('Error', 'Ocurrió un problema al cargar los módulos, $e');
      }
    }
  }

  List<EntrenamientoModulo> obtenerModulosPorEntrenamiento(int trainingKey) {
    return modulosPorEntrenamiento[trainingKey]?.toList() ?? [];
  }

  Future<EntrenamientoModulo?> obtenerUltimoEntrenamientoPorPersona(
      int personaId) async {
    try {
      final response = await entrenamientoService
          .obtenerUltimoEntrenamientoPorPersona(personaId);

      log('Entrenamiento: ${response.data}');
      if (response.success) {
        var entrenamientoModulo = response.data as EntrenamientoModulo;

        return entrenamientoModulo;
      }
    } catch (e) {
      log('Error al cargar los módulos: $e');
      Get.snackbar('Error', 'Ocurrió un problema al cargar los módulos, $e');
      return null;
    }
    return null;
  }

  Future<bool> actualizarEntrenamiento(EntrenamientoModulo training) async {
    try {
      final response = await entrenamientoService.updateEntrenamiento(training);

      if (response.success) {
        int index = trainingList.indexWhere((t) => t.key == training.key);
        if (index != -1) {
          trainingList[index] = training;
          trainingList.refresh();
        }
        EntrenamientoNuevoController controller =
            Get.put(EntrenamientoNuevoController());
        await controller.registrarArchivos(training.key!);
        controller.archivosAdjuntos.clear();
        //controller.documentoAdjuntoNombre.value = '';
        //controller.documentoAdjuntoBytes.value = null;
        Get.snackbar(
          'Éxito',
          'Entrenamiento actualizado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'No se pudo actualizar el entrenamiento',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un problema al actualizar el entrenamiento',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> eliminarEntrenamiento(EntrenamientoModulo training) async {
    try {
      final response =
          await entrenamientoService.eliminarEntrenamiento(training);
      if (response.success) {
        trainingList.remove(training);
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el entrenamiento',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un problema al eliminar el entrenamiento',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> eliminarModulo(EntrenamientoModulo modulo) async {
    try {
      final response = await moduloMaestroService.eliminarModulo(modulo);
      if (response.success) {
        await fetchModulosPorEntrenamiento(modulo.inActividadEntrenamiento!);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'No se pudo eliminar el módulo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un problema al eliminar el módulo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> fetchModulosPorEntrenamiento(int entrenamientoKey) async {
    try {
      final response = await moduloMaestroService
          .listarModulosPorEntrenamiento(entrenamientoKey);
      if (response.success) {
        modulosPorEntrenamiento[entrenamientoKey] =
            RxList<EntrenamientoModulo>(response.data!);
        modulosPorEntrenamiento.refresh();
      } else {
        Get.snackbar('Error', 'No se pudieron cargar los módulos actualizados');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar los módulos');
    }
  }
}
