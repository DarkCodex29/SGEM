import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/personal.dart';

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

  Future<ResponseHandler<Personal>> buscarPersonalPorDni(String dni) async {
    final url =
        '$baseUrl/Personal/ObtenerPersonalPorDocumento?numeroDocumento=$dni';

    try {
      log('Buscando personal por DNI: $dni');
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      log('Respuesta recibida para buscarPersonalPorDni: ${response.data}');
      return ResponseHandler.handleSuccess<Personal>(response.data);
    } on DioException catch (e) {
      log('Error al buscar personal por DNI: $dni. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> registrarPersona(Personal personal) async {
    log('Registrando nueva persona: ${jsonEncode(personal.toJson())}');
    final url = '$baseUrl/Personal/RegistrarPersona';
    try {
      log('Registrando nueva persona: ${jsonEncode(personal.toJson())}');
      final response = await dio.post(
        url,
        data: jsonEncode(personal.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
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
          message: 'Error al registrar persona',
        );
      }
    } on DioException catch (e) {
      log('Error al registrar persona. Datos: ${jsonEncode(personal.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> actualizarPersona(Personal personal) async {
    final url = '$baseUrl/Personal/ActualizarPersona';
    log('Actualizando persona: ${jsonEncode(personal.toJson().toString())}');
    try {
      log('Actualizando persona: ${jsonEncode(personal.toJson())}');
      final response = await dio.put(
        url,
        data: jsonEncode(personal.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      // Verificamos si la respuesta es en formato "Codigo" y "Valor"
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
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
          message: 'Error al actualizar persona',
        );
      }
    } on DioException catch (e) {
      log('Error al actualizar persona. Datos: ${jsonEncode(personal.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<bool>> eliminarPersona(Personal personal) async {
    final url = '$baseUrl/Personal/EliminarPersona';

    try {
      log('Eliminando persona: ${jsonEncode(personal.toJson())}');
      final response = await dio.delete(
        url,
        data: jsonEncode(personal.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == "OK") {
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
          message: 'Error al eliminar persona',
        );
      }
    } on DioException catch (e) {
      log('Error al eliminar persona. Datos: ${jsonEncode(personal.toJson())}, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<List<Personal>>> listarPersonalEntrenamiento({
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
      log('Listando personal de entrenamiento con parámetros: $queryParams');
      final response = await dio.get(
        url,
        queryParameters: queryParams
          ..removeWhere((key, value) => value == null),
        options: Options(
          followRedirects: false,
        ),
      );
      log('Respuesta recibida para listarPersonalEntrenamiento: ${response.data}');
      final personalList = (response.data as List)
          .map((personalJson) => Personal.fromJson(personalJson))
          .toList();
      return ResponseHandler.handleSuccess<List<Personal>>(personalList);
    } on DioException catch (e) {
      log('Error al listar personal de entrenamiento. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<Map<String, dynamic>>>
      listarPersonalEntrenamientoPaginado({
    String? codigoMcp,
    String? numeroDocumento,
    String? nombres,
    String? apellidos,
    int? inGuardia,
    int? inEstado,
    int? pageSize,
    int? pageNumber,
  }) async {
    final url = '$baseUrl/Personal/ListarPersonalEntrenamientoPaginado';
    Map<String, dynamic> queryParams = {
      'parametros.codigoMcp': codigoMcp,
      'parametros.numeroDocumento': numeroDocumento,
      'parametros.nombres': nombres,
      'parametros.apellidos': apellidos,
      'parametros.inGuardia': inGuardia,
      'parametros.inEstado': inEstado,
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
      log('Respuesta recibida para listarPersonalEntrenamientoPaginado: ${response.data}');

      final result = response.data as Map<String, dynamic>;

      final items = result['Items'] as List;
      final personalList =
          items.map((personalJson) => Personal.fromJson(personalJson)).toList();

      final responseData = {
        'Items': personalList,
        'PageNumber': result['PageNumber'],
        'TotalPages': result['TotalPages'],
        'TotalRecords': result['TotalRecords'],
        'PageSize': result['PageSize'],
      };

      return ResponseHandler.handleSuccess<Map<String, dynamic>>(responseData);
    } on DioException catch (e) {
      log('Error al listar personal de entrenamiento paginado. Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }

  Future<ResponseHandler<Uint8List>> obtenerFotoPorCodigoOrigen(
      int idOrigen) async {
    final url =
        '$baseUrl/Personal/ObtenerPersonalFotoPorCodigoOrigen?idOrigen=$idOrigen';
    try {
      log('Obteniendo foto para el código de origen: $idOrigen');
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        log('Foto obtenida con éxito para el idOrigen $idOrigen');

        final jsonResponse = response.data;
        if (jsonResponse.containsKey('Datos')) {
          Uint8List imageData =
              Uint8List.fromList(List<int>.from(jsonResponse['Datos']));
          return ResponseHandler.handleSuccess<Uint8List>(imageData);
        } else {
          return ResponseHandler(
            success: false,
            message: 'No se encontraron datos de imagen en la respuesta',
          );
        }
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al obtener la foto del personal',
        );
      }
    } on DioException catch (e) {
      log('Error al obtener la foto del personal. idOrigen: $idOrigen, Error: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
