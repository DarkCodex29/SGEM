import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';


class ModuloMaestroService{
  final Dio dio = Dio();

  ModuloMaestroService() {
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
  Future<ResponseHandler<List<ModuloMaestro>>> listarMaestros() async {
    const url = '${ConfigFile.apiUrl}/modulo/ListarModuloMaestro';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<ModuloMaestro> maestros = List<ModuloMaestro>.from(
          response.data.map((json) => ModuloMaestro.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<List<ModuloMaestro>>(maestros);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar modulos',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<ModuloMaestro>>(e);
    }
  }
  Future<ResponseHandler<bool>> registrarModulo(
      EntrenamientoModulo entrenamientoModulo) async {
    log('Registrando nuevo entrenamiento: ${jsonEncode(entrenamientoModulo.toJson())}');
    const url = '${ConfigFile.apiUrl}/Modulo/RegistrarModulo';
    try {
      log('Registrando nuevo entrenamiento: ${jsonEncode(entrenamientoModulo.toJson())}');
      final response = await dio.post(
        url,
        data: jsonEncode(entrenamientoModulo.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );
      log("RESPONSE: $response");
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
          message: 'Error al registrar modulo',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar modulo. Datos: ${jsonEncode(entrenamientoModulo.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}