import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/monitoring.dart';
import 'package:sgem/shared/modules/monitoring.save.dart';

class MonitoringService {
  final String baseUrl = ConfigFile.apiUrl;

  final Dio dio = Dio();

  Future<ResponseHandler<Map<String, dynamic>>> queryMonitoringPaginated(
      {String? codigoMcp,
      String? apellidoPaterno,
      String? apellidoMaterno,
      String? nombres,
      int? inGuardia,
      int? inEstadoEntrenamiento,
      int? inEquipo,
      int? inEntrenador,
      int? inCondicion,
      DateTime? fechaInicio,
      DateTime? fechaTermino,
      int? pageSize,
      int? pageNumber,
      bool isPaginate = true}) async {
    String url = "$baseUrl/monitoreo/MonitoreoConsultaPaginado";
    if (!isPaginate) {
      url = '$baseUrl/monitoreo/MonitoreoConsulta';
    }
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.apellidoPaterno': apellidoPaterno,
      'parametros.apellidoMaterno': apellidoMaterno,
      'parametros.nombres': nombres,
      'parametros.inGuardia': inGuardia,
      'parametros.inEstadoEntrenamiento': inEstadoEntrenamiento,
      'parametros.inEntrenador': inEntrenador,
      'parametros.inCondicion': inCondicion,
      'parametros.fechaInicio': fechaInicio,
      'parametros.fechaTermino': fechaTermino,
      'parametros.pageSize': pageSize,
      'parametros.pageNumber': pageNumber,
    };

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams
          ..removeWhere((key, value) => value == null),
        options: Options(
          followRedirects: false,
        ),
      );
      List<Monitoring> personalList = [];
      Map<String, dynamic> responseData;
      if (isPaginate) {
        final result = response.data as Map<String, dynamic>;

        final items = result['Items'] as List;
        personalList = items
            .map((personalJson) => Monitoring.fromJson(personalJson))
            .toList();
        responseData = {
          'Items': personalList,
          'PageNumber': result['PageNumber'],
          'TotalPages': result['TotalPages'],
          'TotalRecords': result['TotalRecords'],
          'PageSize': result['PageSize'],
        };
        return ResponseHandler.handleSuccess<Map<String, dynamic>>(
            responseData);
      }
      final result = response.data as List;
      personalList = result
          .map((personalJson) => Monitoring.fromJson(personalJson))
          .toList();
      responseData = {
        'Items': personalList,
      };

      return ResponseHandler.handleSuccess<Map<String, dynamic>>(responseData);
    } on DioException catch (e) {
      log('Error al listar monitorieo  paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<Map<String, dynamic>> searchMonitoringDetailById(int key) async {
    try {
      final response = await dio.get(
        '$baseUrl/monitoreo/ObtenerMonitoreoPorId?idMonitoreo=$key',
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        return response.data;
      } else {
        throw Exception('Error al buscar monitoreo por id: $key');
      }
    } on DioException catch (e) {
      log('Error al buscar monitoreo. $e');
      throw Exception('Error al buscar monitoreo por id: $key');
    }
  }

  Future<ResponseHandler<bool>> updateMonitoring(
      MonitoingSave monitoring) async {
    final url = '$baseUrl/monitoreo/ActualizarMonitoreo';
    try {
      log(jsonEncode(monitoring.toJson()));
      final response = await dio.put(
        url,
        data: jsonEncode(monitoring.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data == true) {
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
          message: 'Error al registrar monitoreo',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar monitoreo. Datos: ${jsonEncode(monitoring.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> registerMonitoring(
      MonitoingSave monitoring) async {
    final url = '$baseUrl/monitoreo/RegistrarMonitoreo';
    try {
      log(jsonEncode(monitoring.toJson()));
      final response = await dio.post(
        url,
        data: jsonEncode(monitoring.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data == true) {
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
          message: 'Error al registrar monitoreo',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar monitoreo. Datos: ${jsonEncode(monitoring.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> deleteMonitoring(
      MonitoingSave monitoring) async {
    final url = '$baseUrl/monitoreo/EliminarMonitoreo';
    try {
      log(jsonEncode(monitoring.toJson()));
      final response = await dio.delete(
        url,
        data: jsonEncode(monitoring.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data == true) {
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
          message: 'Error al registrar monitoreo',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar monitoreo. Datos: ${jsonEncode(monitoring.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
