import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';

import '../../shared/modules/capacitacion.consulta.dart';
import '../constants/config.dart';

class CapacitacionService{
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
    const url = '${ConfigFile.apiUrl}/Capacitacion/CapacitacionConsultaPaginado';
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
}