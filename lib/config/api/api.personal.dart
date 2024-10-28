import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/personal.dart';

class PersonalService {
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
        '${ConfigFile.apiUrl}/Personal/ObtenerPersonalPorDocumento?numeroDocumento=$dni';

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

  Future<Map<String, dynamic>> buscarPersonalPorId(String id) async {
    final url = '${ConfigFile.apiUrl}/Personal/ObtenerPersonalPorId?id=$id';

    try {
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        log('Personal encontrado con DNI $id');
        return response.data;
      } else {
        throw Exception('No se encontraron datos para el DNI $id');
      }
    } on DioException catch (e) {
      log('Error en la solicitud: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Error al buscar la persona por dni: $id');
    }
  }

  Future<ResponseHandler<bool>> registrarPersona(Personal personal) async {
    log('Registrando nueva persona: ${jsonEncode(personal.toJson())}');
    const url = '${ConfigFile.apiUrl}/Personal/RegistrarPersona';
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
    const url = '${ConfigFile.apiUrl}/Personal/ActualizarPersona';
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
    const url = '${ConfigFile.apiUrl}/Personal/EliminarPersona';

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
    const url = '${ConfigFile.apiUrl}/Personal/ListarPersonalEntrenamiento';
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

  Future<ResponseHandler<Personal>> obtenerPersonalExternoPorNumeroDocumento(
      String numeroDocumento) async {
    final url =
        '${ConfigFile.apiUrl}/Personal/ObtenerPersonalExternoPorNumeroDocumento?numeroDocumento=$numeroDocumento';

    try {
      log('Buscando personal externo por número de documento: $numeroDocumento');
      final response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      log('Respuesta recibida para obtenerPersonalExternoPorNumeroDocumento: ${response.data}');

      return ResponseHandler.handleSuccess<Personal>(
          Personal.fromJson(response.data));
    } on DioException catch (e) {
      log('Error al obtener personal externo por número de documento: $numeroDocumento. Error: ${e.response?.data}');
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
    const url =
        '${ConfigFile.apiUrl}/Personal/ListarPersonalEntrenamientoPaginado';
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
        '${ConfigFile.apiUrl}/Personal/ObtenerPersonalFotoPorCodigoOrigen?idOrigen=$idOrigen';
    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
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

  Future<ResponseHandler<List<Personal>>> listarEntrenadores() async {
    const url = '${ConfigFile.apiUrl}/Personal/ListarEntrenadores';

    try {
      log('Solicitando lista de entrenadores...');
      final response = await dio.get(
        url,
        options: Options(followRedirects: false),
      );

      log('Respuesta recibida para listarEntrenadores: ${response.data}');

      final entrenadoresList = (response.data as List)
          .map((entrenadorJson) => Personal.fromJson(entrenadorJson))
          .toList();

      return ResponseHandler.handleSuccess<List<Personal>>(entrenadoresList);
    } on DioException catch (e) {
      log('Error al listar entrenadores: ${e.response?.data}');
      return ResponseHandler.handleFailure(e);
    }
  }
}
