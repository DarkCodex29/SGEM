import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/models/models.dart';

class RolPermisoService {
  RolPermisoService({
    Dio? dio,
  }) : _dio = dio ?? Dio(_options);

  final Dio _dio;

  static final BaseOptions _options = BaseOptions(
    baseUrl: '${ConfigFile.apiUrl}/RolPermiso',
    contentType: Headers.jsonContentType,
    followRedirects: false,
  );

  Future<ResponseHandler<List<Rol>>> getRoles() async {
    try {
      final response = await _dio.get<List<dynamic>>('/VerRoles');

      return ResponseHandler.handleSuccess(
        response.data
                ?.map((e) => Rol.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
    } catch (error, stackTrace) {
      return ResponseHandler.fromError(
        error,
        stackTrace,
        'Error al listar roles',
      );
    }
  }

  Future<ResponseHandler<List<Permiso>>> getPermisos() async {
    try {
      final response = await _dio.get<List<dynamic>>('/VerPermisos');

      return ResponseHandler.handleSuccess(
        response.data
                ?.map((e) => Permiso.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
    } catch (error, stackTrace) {
      return ResponseHandler.fromError(
        error,
        stackTrace,
        'Error al listar permisos',
      );
    }
  }

  Future<ResponseHandler<List<Permiso>>> getPermisosPorRol({
    required int rol,
  }) async {
    try {
      final params = <String, dynamic>{
        'rol': rol,
      };

      final response = await _dio.get<List<dynamic>>(
        '/VerPermisosPorRol',
        queryParameters: params,
      );

      return ResponseHandler.handleSuccess(
        response.data
                ?.map((e) => Permiso.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
    } catch (error, stackTrace) {
      return ResponseHandler.fromError(
        error,
        stackTrace,
        'Error al listar permisos',
      );
    }
  }

  Future<ResponseHandler<bool>> registrateRol(
    Rol data,
  ) async {
    try {
      Logger('RolPermisoService')
          .info('Registrando rol ${jsonEncode(data.toJson())}');
      await _dio.post<dynamic>(
        '/RegistrarRol',
        data: data.toJson(),
      );

      return ResponseHandler.handleSuccess(true);
    } catch (e, stackTrace) {
      return ResponseHandler.fromError(
        e,
        stackTrace,
        'Error al registrar rol',
      );
    }
  }

  Future<ResponseHandler<bool>> updateRol(
    Rol data,
  ) async {
    try {
      await _dio.put<dynamic>(
        '/ActualizarRol',
        data: data.toJson(),
      );

      return ResponseHandler.handleSuccess(true);
    } catch (e, stackTrace) {
      return ResponseHandler.fromError(
        e,
        stackTrace,
        'Error al actualizar rol',
      );
    }
  }

  Future<ResponseHandler<bool>> updatePermiso(
    Permiso data,
  ) async {
    try {
      await _dio.put<dynamic>(
        '/ActualizarPermiso',
        data: data.toJson(),
      );

      return ResponseHandler.handleSuccess(true);
    } catch (e, stackTrace) {
      return ResponseHandler.fromError(
        e,
        stackTrace,
        'Error al actualizar permiso',
      );
    }
  }
}
