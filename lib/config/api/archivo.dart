import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';

class ArchivoService {
  final String baseUrl =
      'https://chinalco-dev-sgm-backend-g0bdc2cze6afhzg8.canadaeast-01.azurewebsites.net/api';
  final Dio dio = Dio();

  ArchivoService() {
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

  Future<ResponseHandler<bool>> registrarArchivo({
    required int key,
    required String nombre,
    required String extension,
    required String mime,
    required String datos,
    required int inTipoArchivo,
    required int inOrigen,
    re
  }) async {
    final url = '$baseUrl/Archivo/RegistrarArchivo';

    Map<String, dynamic> requestBody = {
      "Key": key,
      "Nombre": nombre,
      "Extension": extension,
      "Mime": mime,
      "Datos": datos,
      "InTipoArchivo": inTipoArchivo,
      "InOrigen": inOrigen,
    };

    try {
      log('Registrando archivo: $requestBody');
      final response = await dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ResponseHandler.handleSuccess<bool>(true);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al registrar archivo',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar archivo. Datos: $requestBody, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
