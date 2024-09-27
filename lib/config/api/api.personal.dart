import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class PersonalService {
  final String baseUrl =
      'https://chinalco-dev-sgm-backend-g0bdc2cze6afhzg8.canadaeast-01.azurewebsites.net/api';

  final Dio dio = Dio();

  PersonalService() {
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

  Future<Map<String, dynamic>> buscarPersonalPorDni(String dni) async {
    final url =
        '$baseUrl/Personal/ObtenerPersonalPorDocumento?numeroDocumento=$dni';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        log('Personal encontrado con DNI $dni');
        return response.data;
      } else {
        throw Exception('No se encontraron datos para el DNI $dni');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al buscar personal: ${e.message}');
    }
  }

  Future<bool> registrarPersona(Map<String, dynamic> data) async {
    final url = '$baseUrl/Personal/RegistrarPersona';

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data == true) {
        log('Persona registrada correctamente');
        return true;
      } else {
        throw Exception('Error al registrar persona, respuesta inesperada');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al registrar persona: ${e.message}');
    }
  }

  Future<bool> actualizarPersona(Map<String, dynamic> data) async {
    final url = '$baseUrl/Personal/ActualizarPersona';

    try {
      final response = await dio.put(
        url,
        data: jsonEncode(data),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data == true) {
        log('Persona actualizada correctamente');
        return true;
      } else {
        throw Exception('Error al actualizar persona, respuesta inesperada');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al actualizar persona: ${e.message}');
    }
  }

  Future<bool> eliminarPersona(Map<String, dynamic> data) async {
    final url = '$baseUrl/Personal/EliminarPersona';

    try {
      final response = await dio.delete(
        url,
        data: jsonEncode(data),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data == true) {
        log('Persona eliminada correctamente');
        return true;
      } else {
        throw Exception('Error al eliminar persona, respuesta inesperada');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al eliminar persona: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> listarPersonalEntrenamiento({
    String? codigoMcp,
    String? numeroDocumento,
    String? nombres,
    String? apellidos,
    int? inGuardia,
    int? inEstado,
  }) async {
    final url = '$baseUrl/Personal/ListarPersonalEntrenamiento';
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.numeroDOcumento': numeroDocumento,
      'parametros.nombres': nombres,
      'parametros.apellidos': apellidos,
      'parametros.inGuardia': inGuardia,
      'parametros.inEstado': inEstado,
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
        throw Exception('Error al listar personal de entrenamiento');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception(
          'Error al listar personal de entrenamiento: ${e.message}');
    }
  }
}
