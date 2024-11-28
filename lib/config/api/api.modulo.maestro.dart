import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/modules/modulo_model.dart';

class ModuloMaestroService {
  ModuloMaestroService({
    Dio? dio,
  }) : _dio = dio ?? Dio(_options);

  final Dio _dio;

  static final BaseOptions _options = BaseOptions(
    baseUrl: '${ConfigFile.apiUrl}/modulo',
    contentType: Headers.jsonContentType,
    followRedirects: false,
  );

  Future<ResponseHandler<List<EntrenamientoModulo>>>
      listarModulosPorEntrenamiento(int entrenamientoId) async {
    final url =
        '${ConfigFile.apiUrl}/modulo/ListarModulosPorEntrenamiento/$entrenamientoId';

    try {
      final response = await _dio.get(
        url,
        options: Options(followRedirects: false),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<EntrenamientoModulo> modulos = List<EntrenamientoModulo>.from(
          response.data.map((json) => EntrenamientoModulo.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<List<EntrenamientoModulo>>(
            modulos);
      } else {
        return const ResponseHandler(
          success: false,
          message: 'Error al listar los módulos por entrenamiento',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<EntrenamientoModulo>>(e);
    }
  }

  /// Obtiene los módulos de un entrenamiento
  Future<ResponseHandler<List<Modulo>>> getModules() async {
    try {
      final response = await _dio.get<List<dynamic>>('/ListarModuloMaestro');

      return ResponseHandler.handleSuccess(
        response.data
                ?.map((e) => Modulo.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
    } catch (e, stackTrace) {
      return ResponseHandler.fromError(
        e,
        stackTrace,
        'Error al listar modulos',
      );
    }
  }

  @Deprecated('Use getModules instead')
  Future<ResponseHandler<List<ModuloMaestro>>> listarMaestros() async {
    const url = '${ConfigFile.apiUrl}/modulo/ListarModuloMaestro';

    try {
      final response = await _dio.get(
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
        return const ResponseHandler(
          success: false,
          message: 'Error al listar modulos',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<ModuloMaestro>>(e);
    }
  }

  Future<ResponseHandler<EntrenamientoModulo>> obtenerModuloPorId(
      int moduloId) async {
    final url = '${ConfigFile.apiUrl}/modulo/ObtenerModuloPorId/$moduloId';
    log('Api modulo obtener modulo por id $moduloId');
    try {
      log('Api: $url');
      final response = await _dio.get(
        url,
        options: Options(followRedirects: false),
      );

      if (response.statusCode == 200 && response.data != null) {
        log('Api modulo, obtenido con exito');

        EntrenamientoModulo modulo =
            EntrenamientoModulo.fromJson(response.data);
        log('Api modulo, ${response.data}');
        return ResponseHandler.handleSuccess<EntrenamientoModulo>(modulo);
      } else {
        log('Api modulo, error al obtener modulo por id');

        return const ResponseHandler(
          success: false,
          message: 'Error al obtener el módulo por ID',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<EntrenamientoModulo>(e);
    }
  }

  Future<ResponseHandler<ModuloMaestro>> obtenerModuloMaestroPorId(
      int maestroId) async {
    log('Obteniendo módulo maestro por ID: $maestroId');
    final url =
        '${ConfigFile.apiUrl}/modulo/ObtenerModuloMaestroPorId/$maestroId';

    try {
      final response = await _dio.get(
        url,
        options: Options(followRedirects: false),
      );
      log('Response: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        return ResponseHandler.handleSuccess<ModuloMaestro>(response.data);
      } else {
        return const ResponseHandler(
          success: false,
          message: 'Error al obtener el módulo maestro por ID',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<ModuloMaestro>(e);
    }
  }

  Future<ResponseHandler<bool>> _manageModulo(
      String url, String method, EntrenamientoModulo modulo) async {
    log('$method modulo: ${jsonEncode(modulo.toJson())}');

    try {
      Response response;
      Logger('ApiModuloMAestro').info('Modulo actualizar: ${jsonEncode(modulo.toJson())}');
      if (method == 'POST') {
        response = await _dio.post(url, data: jsonEncode(modulo.toJson()));
      } else if (method == 'PUT') {
        response = await _dio.put(url, data: jsonEncode(modulo.toJson()));
      } else if (method == 'DELETE') {
        response = await _dio.delete(url, data: jsonEncode(modulo.toJson()));
      } else {
        return const ResponseHandler(
          success: false,
          message: 'Método HTTP no soportado',
        );
      }

      if (response.statusCode == 200 && response.data != null) {
        log('Respuesta de mnodulo: ${response}');
        if (response.data is bool && response.data) {
          return ResponseHandler.handleSuccess<bool>(true);
        } else if (response.data is Map<String, dynamic> &&
            response.data.containsKey('Message')) {
          return ResponseHandler(
            success: false,
            message: response.data['Message'] ?? 'Error desconocido',
          );
        } else {
          return const ResponseHandler(
            success: false,
            message: 'Formato de respuesta inesperado al manejar el módulo',
          );
        }
      } else {
        return const ResponseHandler(
          success: false,
          message: 'Error al manejar el módulo',
        );
      }
    } on DioException catch (e) {
      log('Error al manejar el módulo. Datos: ${jsonEncode(modulo.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> updateModulo(
    Modulo data,
  ) async {
    try {
      await _dio.put<dynamic>(
        '/ActualizarModuloMaestro',
        data: data.toJson(),
      );

      return ResponseHandler.handleSuccess(true);
    } catch (e, stackTrace) {
      return ResponseHandler.fromError(
        e,
        stackTrace,
        'Error al actualizar módulo',
      );
    }
  }

  Future<ResponseHandler<bool>> registrarModulo(
      EntrenamientoModulo modulo) async {
    const url = '${ConfigFile.apiUrl}/modulo/RegistrarModulo';
    return _manageModulo(url, 'POST', modulo);
  }

  Future<ResponseHandler<bool>> actualizarModulo(
      EntrenamientoModulo modulo) async {
    const url = '${ConfigFile.apiUrl}/modulo/ActualizarModulo';
    return _manageModulo(url, 'PUT', modulo);
  }

  Future<ResponseHandler<bool>> eliminarModulo(
      EntrenamientoModulo modulo) async {
    const url = '${ConfigFile.apiUrl}/modulo/EliminarModulo';
    return _manageModulo(url, 'DELETE', modulo);
  }
}
