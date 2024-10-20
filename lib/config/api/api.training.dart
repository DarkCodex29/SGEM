import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/entrenamiento.actualizacion.masiva.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';

import '../../shared/modules/entrenamiento.consulta.dart';

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
      EntrenamientoModulo entrenamiento) async {
    const url = '${ConfigFile.apiUrl}/Entrenamiento/RegistrarEntrenamiento';
    try {
      final response = await dio.post(
        url,
        data: jsonEncode(entrenamiento.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );
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
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<EntrenamientoModulo>>
      obtenerUltimoModuloPorEntrenamiento(int entrenamientoId) async {
    final url =
        '$baseUrl/Entrenamiento/ObtenerUltimoModuloPorEntrenamiento?inEntrenamiento=$entrenamientoId';
    try {
      final response =
          await dio.get(url, options: Options(followRedirects: false));

      if (response.statusCode == 200 && response.data != null) {
        try {
          EntrenamientoModulo ultimoModulo =
              EntrenamientoModulo.fromJson(response.data);
          return ResponseHandler<EntrenamientoModulo>(
              success: true, data: ultimoModulo);
        } catch (e) {
          return ResponseHandler<EntrenamientoModulo>(
            success: false,
            message: 'Error al mapear los datos a EntrenamientoModulo.',
          );
        }
      } else {
        log('Error en la respuesta del servidor: ${response.statusCode}, Datos: ${response.data}');
        return ResponseHandler<EntrenamientoModulo>(
          success: false,
          message: 'Error al obtener el último módulo',
        );
      }
    } on DioException catch (e) {
      log('Error al obtener el último módulo para el entrenamiento con ID: $entrenamientoId. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure<EntrenamientoModulo>(e);
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
      EntrenamientoModulo training) async {
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
      EntrenamientoModulo training) async {
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

  Future<ResponseHandler<Map<String, dynamic>>> consultarEntrenamientoPaginado({
    String? codigoMcp,
    int? inEquipo,
    int? inModulo,
    int? inGuardia,
    int? inEstadoEntrenamiento,
    int? inCondicion,
    DateTime? fechaInicio,
    DateTime? fechaTermino,
    String? nombres,
    int? pageSize,
    int? pageNumber,
  }) async {
    final url = '$baseUrl/Entrenamiento/EntrenamientoConsultarPaginado';
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.inEquipo': inEquipo,
      'parametros.inModulo': inModulo,
      'parametros.inGuardia': inGuardia,
      'parametros.inEstadoEntrenamiento': inEstadoEntrenamiento,
      'parametros.inCondicion': inCondicion,
      'parametros.fechaInicio': fechaInicio,
      'parametros.fechaTermino': fechaTermino,
      'parametros.nombres': nombres,
      'parametros.pageSize': pageSize,
      'parametros.pageNumber': pageNumber,
    };
    try {
      log('Listando personal de entrenamiento paginado con parámetros: $queryParams');
      final response = await dio.get(
        url,
        queryParameters: queryParams
          ..removeWhere((key, value) => value == null),
        options: Options(
          followRedirects: false,
        ),
      );

      log('Respuesta recibida para consultarEntrenamientoPaginado: ${response.data}');

      final result = response.data as Map<String, dynamic>;

      final items = result['Items'] as List;
      final entrenamientoList = items
          .map((entrenamientoJson) =>
              EntrenamientoConsulta.fromJson(entrenamientoJson))
          .toList();

      final responseData = {
        'Items': entrenamientoList,
        'PageNumber': result['PageNumber'],
        'TotalPages': result['TotalPages'],
        'TotalRecords': result['TotalRecords'],
        'PageSize': result['PageSize'],
      };

      return ResponseHandler.handleSuccess<Map<String, dynamic>>(responseData);
    } on DioException catch (e) {
      log('Error al consultar entrenamientos paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<Map<String, dynamic>>> ActualizacionMasivaPaginado({
    String? codigoMcp,
    String? numeroDocumento,
    int? inGuardia,
    String? nombres,
    String? apellidos,
    int? inEquipo,
    int? inModulo,

    int? pageSize,
    int? pageNumber,
  }) async {
    log('Llamando al endpoint actuaalizacion masiva');
    const url = '${ConfigFile.apiUrl}/Entrenamiento/EntrenamientoActualizacionMasivaPaginado';
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.numeroDocumento': numeroDocumento,
      'parametros.inGuardia': inGuardia,
      'parametros.nombres': nombres,
      'parametros.apellidos': apellidos,
      'parametros.inEquipo': inEquipo,
      'parametros.inModulo': inModulo,

      'parametros.pageSize': pageSize,
      'parametros.pageNumber': pageNumber,
    };
    try {
      log('Listando personal de entrenamiento paginado con parámetros: $queryParams');
      final response = await dio.get(
        url,
        queryParameters: queryParams
          ..removeWhere((key, value) => value == null),
        options: Options(
          followRedirects: false,
        ),
      );

      log('Respuesta recibida para actualizacion masiva Paginado: ${response.data}');

      final result = response.data as Map<String, dynamic>;

      final items = result['Items'] as List;
      final entrenamientoList = items
          .map((entrenamientoJson) =>
          EntrenamientoActualizacionMasiva.fromJson(entrenamientoJson))
          .toList();

      final responseData = {
        'Items': entrenamientoList,
        'PageNumber': result['PageNumber'],
        'TotalPages': result['TotalPages'],
        'TotalRecords': result['TotalRecords'],
        'PageSize': result['PageSize'],
      };

      return ResponseHandler.handleSuccess<Map<String, dynamic>>(responseData);
    } on DioException catch (e) {
      log('Error al consultar entrenamientos paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
