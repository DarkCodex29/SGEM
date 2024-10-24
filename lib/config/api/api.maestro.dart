import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/maestro.dart';

class MaestroService {
  final Dio dio = Dio();

  MaestroService() {
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

  Future<ResponseHandler<List<MaestroCompleto>>> listarMaestros() async {
    const url = '${ConfigFile.apiUrl}/Maestro/ListarMaestros';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<MaestroCompleto> maestros = List<MaestroCompleto>.from(
          response.data.map((json) => MaestroCompleto.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<List<MaestroCompleto>>(maestros);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar maestros',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<MaestroCompleto>>(e);
    }
  }

  Future<ResponseHandler<bool>> registrarMaestro(
      MaestroCompleto maestro) async {
    const url = '${ConfigFile.apiUrl}/Maestro/RegistrarMaestro';

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(maestro.toJson()),
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
          message: 'Error al registrar maestro',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> actualizarMaestro(
      MaestroCompleto maestro) async {
    const url = '${ConfigFile.apiUrl}/Maestro/ActualizarMaestro';

    try {
      final response = await dio.put(
        url,
        data: jsonEncode(maestro.toJson()),
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
          message: 'Error al actualizar maestro',
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['Message'] != null) {
        var errorMessage = e.response!.data['Message'];
        log('Error al actualizar: $errorMessage');
        return ResponseHandler(
          success: false,
          message: 'Error al actualizar maestro: $errorMessage',
        );
      } else {
        return ResponseHandler.handleFailure<bool>(e);
      }
    }
  }
}
