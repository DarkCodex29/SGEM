import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.training.dart';
import 'package:sgem/shared/modules/training.dart';

class TrainingPersonalController extends GetxController {
  var trainingList = <Entrenamiento>[].obs;
  final TrainingService trainingService = TrainingService();

  Future<void> fetchTrainings(int personId) async {
    try {
      final response =
          await trainingService.listarEntrenamientoPorPersona(personId);
      if (response.success) {
        trainingList.value =
            response.data!.map((json) => Entrenamiento.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'No se pudieron cargar los entrenamientos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar los entrenamientos');
    }
  }

  Future<void> eliminarEntrenamiento(Entrenamiento training) async {
    try {
      final response = await trainingService.eliminarEntrenamiento(training);
      if (response.success) {
        trainingList.remove(training);
        Get.snackbar('Éxito', 'Entrenamiento eliminado correctamente',
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.black);
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el entrenamiento');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al eliminar el entrenamiento');
    }
  }
}
