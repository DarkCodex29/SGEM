import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import '../../shared/modules/capacitacion.consulta.dart';
import '../constants/config.dart';

class CapacitacionService {
  final Dio dio = Dio();

  CapacitacionService() {
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

  Future<ResponseHandler<Map<String, dynamic>>> CapacitacionConsultaPaginado({
    String? codigoMcp,
    String? numeroDocumento,
    int? inGuardia,
    String? nombres,
    String? apellidoPaterno,
    String? apellidoMaterno,
    int? inCapacitacion,
    int? inCategoria,
    int? inEmpresaCapacitacion,
    int? inEntrenador,
    DateTime? fechaInicio,
    DateTime? fechaTermino,
    int? pageSize,
    int? pageNumber,
  }) async {
    log('Llamando al endpoint actuaalizacion masiva');
    const url =
        '${ConfigFile.apiUrl}/Capacitacion/CapacitacionConsultaPaginado';
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.numeroDocumento': numeroDocumento,
      'parametros.inGuardia': inGuardia,
      'parametros.nombres': nombres,
      'parametros.apellidoPaterno': apellidoPaterno,
      'parametros.apellidoMaterno': apellidoMaterno,
      'parametros.inCapacitacion': inCapacitacion,
      'parametros.inCategoria': inCategoria,
      'parametros.inEmpresaCapacitacion': inEmpresaCapacitacion,
      'parametros.inEntrenador': inEntrenador,
      'parametros.fechaInicio': fechaInicio,
      'parametros.fechaTermino': fechaTermino,
      'parametros.pageSize': pageSize,
      'parametros.pageNumber': pageNumber,
    };
    try {
      log('Listando capacitacion paginado con parámetros: $queryParams');
      final response = await dio.get(
        url,
        queryParameters: queryParams
          ..removeWhere((key, value) => value == null),
        options: Options(
          followRedirects: false,
        ),
      );

      log('Respuesta recibida para capacitacion Paginado: ${response.data}');

      final result = response.data as Map<String, dynamic>;

      final items = result['Items'] as List;
      final capacitacionList = items
          .map((entrenamientoJson) =>
              CapacitacionConsulta.fromJson(entrenamientoJson))
          .toList();

      final responseData = {
        'Items': capacitacionList,
        'PageNumber': result['PageNumber'],
        'TotalPages': result['TotalPages'],
        'TotalRecords': result['TotalRecords'],
        'PageSize': result['PageSize'],
      };

      return ResponseHandler.handleSuccess<Map<String, dynamic>>(responseData);
    } on DioException catch (e) {
      log('Error al consultar capacitaciones paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> _manageCapacitacion(
      String url, String method, EntrenamientoModulo capacitacion) async {
    log('$method modulo: ${jsonEncode(capacitacion.toJson())}');

    try {
      Response response;

      if (method == 'POST') {
        response = await dio.post(url, data: jsonEncode(capacitacion.toJson()));
      } else if (method == 'PUT') {
        response = await dio.put(url, data: jsonEncode(capacitacion.toJson()));
      } else if (method == 'DELETE') {
        response =
            await dio.delete(url, data: jsonEncode(capacitacion.toJson()));
      } else {
        return ResponseHandler(
          success: false,
          message: 'Método HTTP no soportado',
        );
      }

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is bool && response.data) {
          return ResponseHandler.handleSuccess<bool>(true);
        } else if (response.data is Map<String, dynamic> &&
            response.data.containsKey('Message')) {
          return ResponseHandler(
            success: false,
            message: response.data['Message'] ?? 'Error desconocido',
          );
        } else {
          return ResponseHandler(
            success: false,
            message: 'Formato de respuesta inesperado al manejar el módulo',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al manejar el módulo',
        );
      }
    } on DioException catch (e) {
      log('Error al manejar el módulo. Datos: ${jsonEncode(capacitacion.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> registrarModulo(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/modulo/RegistrarModulo';
    return _manageCapacitacion(url, 'POST', capacitacion);
  }

  Future<ResponseHandler<bool>> actualizarModulo(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/modulo/ActualizarModulo';
    return _manageCapacitacion(url, 'PUT', capacitacion);
  }

  Future<ResponseHandler<bool>> eliminarModulo(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/modulo/EliminarModulo';
    return _manageCapacitacion(url, 'DELETE', capacitacion);
  }
}
