import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';

class ModuloMaestroService {
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

  Future<ResponseHandler<List<ModuloMaestro>>> listarModulosPorEntrenamiento(
      int entrenamientoId) async {
    final url =
        '${ConfigFile.apiUrl}/modulo/ListarModulosPorEntrenamiento/$entrenamientoId';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<ModuloMaestro> modulos = List<ModuloMaestro>.from(
          response.data.map((json) => ModuloMaestro.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<List<ModuloMaestro>>(modulos);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar los módulos por entrenamiento',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<ModuloMaestro>>(e);
    }
  }
}
