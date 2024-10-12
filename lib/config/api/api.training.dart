import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/registrar.training.dart';
import 'package:sgem/shared/modules/training.dart';

class TrainingService {
  final String baseUrl =
      'https://chinalco-dev-sgm-backend-g0bdc2cze6afhzg8.canadaeast-01.azurewebsites.net/api';

  final Dio dio = Dio();

  TrainingService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
    ));
  }

  Future<ResponseHandler<bool>> registerTraining(
      RegisterTraining registerTraining) async {
    log('Registrando nuevo entrenamiento: ${jsonEncode(registerTraining.toJson())}');
    final url = '$baseUrl/Entrenamiento/RegistrarEntrenamiento';
    try {
      log('Registrando nuevo entrenamiento: ${jsonEncode(registerTraining.toJson())}');
      final response = await dio.post(
        url,
        data: jsonEncode(registerTraining.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );
      log("RESPONSE..: $response");
      if (response.statusCode == 200 && response.data != null) {
        if (response.data) {
          return ResponseHandler.handleSuccess<bool>(true);
        } else {
          return ResponseHandler(
            success: false,
            message: response.data['Message'] ?? 'Error desconocido',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al registrar entrenamiento',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar entrenamiento. Datos: ${jsonEncode(registerTraining.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<List<dynamic>>> listarEntrenamientoPorPersona(
      int id) async {
    final url = '$baseUrl/Entrenamiento/ListarEntrenamientoPorPersona?id=$id';
    try {
      log('Listando entrenamientos para la persona con ID: $id');
      final response =
          await dio.get(url, options: Options(followRedirects: false));
      log('RESPONSE: $response');

      if (response.statusCode == 200 && response.data != null) {
        return ResponseHandler.handleSuccess<List<dynamic>>(response.data);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar entrenamientos',
        );
      }
    } on DioException catch (e) {
      log('Error al listar entrenamientos para la persona con ID: $id. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> actualizarEntrenamiento(
      Entrenamiento training) async {
    final url = '$baseUrl/Entrenamiento/ActualizarEntrenamiento';
    try {
      log('Actualizando entrenamiento: ${jsonEncode(training.toJson())}');
      final response = await dio.put(
        url,
        data: jsonEncode(training.toJson()),
        options: Options(followRedirects: false),
      );
      log('RESPONSE PUT: $response');

      if (response.statusCode == 200 && response.data != null) {
        return ResponseHandler.handleSuccess<bool>(true);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al actualizar el entrenamiento',
        );
      }
    } on DioException catch (e) {
      log('Error al actualizar el entrenamiento. Datos: ${jsonEncode(training.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> eliminarEntrenamiento(
      Entrenamiento training) async {
    final url = '$baseUrl/Entrenamiento/EliminarEntrenamiento';
    try {
      log('Eliminando entrenamiento');
      final response = await dio.delete(
        url,
        data: jsonEncode(training.toJson()),
        options: Options(followRedirects: false),
      );
      log('RESPONSE DELETE: $response');

      if (response.statusCode == 200 && response.data != null) {
        return ResponseHandler.handleSuccess<bool>(true);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al eliminar el entrenamiento',
        );
      }
    } on DioException catch (e) {
      log('Error al eliminar el entrenamiento. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
