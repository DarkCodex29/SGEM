import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

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

  Future<List<Map<String, dynamic>>> listarMaestroDetalle({
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
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Error al listar maestros detalle');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al listar maestros detalle: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> registrarMaestroDetalle(
      Map<String, dynamic> data) async {
    final url = '$baseUrl/MaestroDetalle/RegistrarMaestroDetalle';

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data['Key'] != null) {
        log('Maestro Detalle registrado correctamente');
        return response.data;
      } else {
        throw Exception('Error al registrar maestro detalle');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al registrar maestro detalle: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> actualizarMaestroDetalle(
      Map<String, dynamic> data) async {
    final url = '$baseUrl/MaestroDetalle/ActualizarMaestroDetalle';

    try {
      final response = await dio.put(
        url,
        data: jsonEncode(data),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data['Key'] != null) {
        log('Maestro Detalle actualizado correctamente');
        return response.data;
      } else {
        throw Exception('Error al actualizar maestro detalle');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al actualizar maestro detalle: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> obtenerMaestroDetallePorId(String id) async {
    final url = '$baseUrl/MaestroDetalle/obtenerMaestroDetallePorId?id=$id';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        log('Maestro Detalle encontrado con ID $id');
        return response.data;
      } else {
        throw Exception('No se encontraron datos para el ID $id');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al obtener maestro detalle: ${e.message}');
    }
  }
}
