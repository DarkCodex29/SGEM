import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';

class MaestroDetalleService {
  final String baseUrl =
      'https://chinalco-dev-sgm-backend-g0bdc2cze6afhzg8.canadaeast-01.azurewebsites.net/api';

  final Dio dio = Dio();

  MaestroDetalleService() {
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

  Future<ResponseHandler<List<MaestroDetalle>>> listarMaestroDetalle({
    String? nombre,
    String? descripcion,
  }) async {
    final url = '$baseUrl/MaestroDetalle/ListarMaestrosDetalle';
    Map<String, dynamic> queryParams = {
      'parametros.nombre': nombre,
      'parametros.descripcion': descripcion,
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

      if (response.statusCode == 200 && response.data != null) {
        List<MaestroDetalle> detalles = List<MaestroDetalle>.from(
          response.data.map((json) => MaestroDetalle.fromJson(json)),
        );

        return ResponseHandler.handleSuccess<List<MaestroDetalle>>(detalles);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar maestro detalle',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<MaestroDetalle>>(e);
    }
  }

  Future<ResponseHandler<bool>> registrarMaestroDetalle(
      MaestroDetalle data) async {
    final url = '$baseUrl/MaestroDetalle/RegistrarMaestroDetalle';

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
          log('Maestro Detalle registrado correctamente');
          return ResponseHandler(success: true, data: true);
        } else {
          return ResponseHandler(
            success: false,
            message: 'Error inesperado al registrar maestro detalle',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al registrar maestro detalle',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> actualizarMaestroDetalle(
      MaestroDetalle data) async {
    final url = '$baseUrl/MaestroDetalle/ActualizarMaestroDetalle';

    try {
      final response = await dio.put(
        url,
        data: jsonEncode(data.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
          log('Maestro Detalle actualizado correctamente');
          return ResponseHandler(success: true, data: true);
        } else {
          return ResponseHandler(
            success: false,
            message: 'Error inesperado al actualizar maestro detalle',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al actualizar maestro detalle',
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['Message'] != null) {
        var errorMessage = e.response!.data['Message'];
        log('Error al actualizar: $errorMessage');
        return ResponseHandler(
          success: false,
          message: 'Error al actualizar maestro detalle: $errorMessage',
        );
      } else {
        return ResponseHandler.handleFailure<bool>(e);
      }
    }
  }

  Future<ResponseHandler<MaestroDetalle>> obtenerMaestroDetallePorId(
      String id) async {
    final url = '$baseUrl/MaestroDetalle/obtenerMaestroDetallePorId?id=$id';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        MaestroDetalle detalle = MaestroDetalle.fromJson(response.data);
        return ResponseHandler.handleSuccess<MaestroDetalle>(detalle);
      } else {
        return ResponseHandler(
          success: false,
          message: 'No se encontraron datos para el ID $id',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<MaestroDetalle>(e);
    }
  }

  Future<ResponseHandler<List<MaestroDetalle>>> listarMaestroDetallePorMaestro(int maestroKey) async {
    final url =
        '$baseUrl/MaestroDetalle/ListarMaestroDetallePorMaestro?id=$maestroKey';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<MaestroDetalle> detalles = (response.data as List)
            .map( (json) => MaestroDetalle.fromJson(json as Map<String, dynamic>))
            .toList();
        return ResponseHandler.handleSuccess<List<MaestroDetalle>>(detalles);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar detalles del maestro con Key $maestroKey',
        );
      }
    } on DioException catch (e) {
      log('Error al listar detalles del maestro con Key $maestroKey: $e');
      return ResponseHandler.handleFailure<List<MaestroDetalle>>(e);
    }
  }
}
