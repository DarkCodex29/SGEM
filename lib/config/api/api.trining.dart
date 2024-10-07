

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/registrar.training.dart';

class TriningService {
  final String baseUrl =
      'https://chinalco-dev-sgm-backend-g0bdc2cze6afhzg8.canadaeast-01.azurewebsites.net/api';

  final Dio dio = Dio();

  TriningService() {
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

  Future<ResponseHandler<bool>> registerTraining(RegisterTraining registerTraining) async {
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

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
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
}