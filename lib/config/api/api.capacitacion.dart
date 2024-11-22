import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/capacitacion.carga.masiva.validado.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import '../../shared/modules/capacitacion.carga.masiva.excel.dart';
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

  Future<ResponseHandler<Map<String, dynamic>>> capacitacionConsultaPaginado({
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
    log('Llamando al endpoint consulta paginado');
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
    log('$method capacitación: ${jsonEncode(capacitacion.toJson())}');

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
            message:
                'Formato de respuesta inesperado al manejar la capacitación',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al manejar el capacitación',
        );
      }
    } on DioException catch (e) {
      log('Error al manejar el capacitación. Datos: ${jsonEncode(capacitacion.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> registrarCapacitacion(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/Capacitacion/RegistrarCapacitacion';
    return _manageCapacitacion(url, 'POST', capacitacion);
  }

  Future<ResponseHandler<bool>> actualizarCapacitacion(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/Capacitacion/ActualizarCapacitacion';
    return _manageCapacitacion(url, 'PUT', capacitacion);
  }

  Future<ResponseHandler<bool>> eliminarCapacitacion(
      EntrenamientoModulo capacitacion) async {
    const url = '${ConfigFile.apiUrl}/Capacitacion/EliminarCapacitacion';
    return _manageCapacitacion(url, 'DELETE', capacitacion);
  }

  Future<ResponseHandler<EntrenamientoModulo>> obtenerCapacitacionPorId(
      int idCapacitacion) async {
    const url = '${ConfigFile.apiUrl}/Capacitacion/ObtenerCapacitacionPorId';
    log('Obteniendo capacitación por ID: $idCapacitacion');

    try {
      final response = await dio.get(
        url,
        queryParameters: {'idCapacitacion': idCapacitacion},
      );

      log('Respuesta recibida para ObtenerCapacitacionPorId: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final entrenamiento = EntrenamientoModulo.fromJson(response.data);
        return ResponseHandler.handleSuccess(entrenamiento);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al obtener la capacitación por ID',
        );
      }
    } on DioException catch (e) {
      log('Error al obtener la capacitación por ID: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<List<CapacitacionCargaMasivaValidado>>>
      validarCargaMasiva(
          {required List<CapacitacionCargaMasivaExcel> cargaMasivaList}) async {
    log('Llamando al endpoint carga masiva');
    const url = '${ConfigFile.apiUrl}/Capacitacion/ValidarCargaMasiva';

    final request = cargaMasivaList.map((e) => e.toJson()).toList();

    try {
      log('Enviando datos de capacitación para validación: $request');
      final response = await dio.post(
        url,
        data: request,
      );

      if (response.statusCode == 200 && response.data != null) {
        List<CapacitacionCargaMasivaValidado> cargaMasivaValidada =
            List<CapacitacionCargaMasivaValidado>.from(
          response.data
              .map((json) => CapacitacionCargaMasivaValidado.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<
            List<CapacitacionCargaMasivaValidado>>(cargaMasivaValidada);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar carga masiva',
        );
      }
    } on DioException catch (e) {
      log('Error al consultar capacitaciones paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  /*
  Future<ResponseHandler<bool>>
  cargarMasiva(
      {required List<CapacitacionCargaMasivaExcel> cargaMasivaList}) async {
    log('Llamando al endpoint carga masiva');
    const url = '${ConfigFile.apiUrl}/Capacitacion/ValidarCargaMasiva';

    final request = cargaMasivaList.map((e) => e.toJson()).toList();

    try {
      log('Enviando datos de capacitación para validación: $request');
      final response = await dio.post(
        url,
        data: request,
      );

      if (response.statusCode == 200 && response.data != null) {
        List<CapacitacionCargaMasivaValidado> cargaMasivaValidada =
        List<CapacitacionCargaMasivaValidado>.from(
          response.data
              .map((json) => CapacitacionCargaMasivaValidado.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<
            List<CapacitacionCargaMasivaValidado>>(cargaMasivaValidada);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar carga masiva',
        );
      }
    } on DioException catch (e) {
      log('Error al consultar capacitaciones paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
*/
/*
   Future<ResponseHandler<bool>> registrarCapacitacion(
       EntrenamientoModulo capacitacion) async {
     const url = '${ConfigFile.apiUrl}/Capacitacion/RegistrarCapacitacion';
     return _manageCapacitacion(url, 'POST', capacitacion);
   }

 */
}
