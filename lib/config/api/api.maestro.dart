import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/shared/modules/maestro.dart';
import 'package:sgem/shared/modules/option.value.dart';

class MaestroService {
  MaestroService({
    Dio? dio,
  }) : _dio = dio ?? Dio(_options);

  final Dio _dio;

  static final BaseOptions _options = BaseOptions(
    baseUrl: '${ConfigFile.apiUrl}/Maestro',
    contentType: Headers.jsonContentType,
    followRedirects: false,
  );

  Future<ResponseHandler<List<OptionValue>>> getMaestros() async {
    try {
      final response = await _dio.get<List<dynamic>>('/ListarMaestros');

      return ResponseHandler.handleSuccess(
        response.data
                ?.map((e) => OptionValue.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
    } on DioException catch (e) {
      return ResponseHandler.handleFailure(e);
    } catch (error) {
      debugPrint('Error al listar maestros: $error');

      return ResponseHandler(
        success: false,
        message: 'Error al listar maestros',
      );
    }
  }

  @Deprecated('Usar getMaestros')
  Future<ResponseHandler<List<MaestroCompleto>>> listarMaestros() async {
    const url = '${ConfigFile.apiUrl}/Maestro/ListarMaestros';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<MaestroCompleto> maestros = List<MaestroCompleto>.from(
          response.data.map((json) => MaestroCompleto.fromJson(json)),
        );
        return ResponseHandler.handleSuccess<List<MaestroCompleto>>(maestros);
      } else {
        return ResponseHandler(
          success: false,
          message: 'Error al listar maestros',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<List<MaestroCompleto>>(e);
    }
  }

  Future<ResponseHandler<bool>> registrarMaestro(
    MaestroCompleto maestro,
  ) async {
    const url = '${ConfigFile.apiUrl}/Maestro/RegistrarMaestro';

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(maestro.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == 'OK') {
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
          message: 'Error al registrar maestro',
        );
      }
    } on DioException catch (e) {
      return ResponseHandler.handleFailure<bool>(e);
    }
  }

  Future<ResponseHandler<bool>> actualizarMaestro(
    MaestroCompleto maestro,
  ) async {
    const url = '${ConfigFile.apiUrl}/Maestro/ActualizarMaestro';

    try {
      final response = await _dio.put(
        url,
        data: jsonEncode(maestro.toJson()),
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['Codigo'] == 200 && response.data['Valor'] == 'OK') {
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
          message: 'Error al actualizar maestro',
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['Message'] != null) {
        final errorMessage = e.response!.data['Message'];
        log('Error al actualizar: $errorMessage');
        return ResponseHandler(
          success: false,
          message: 'Error al actualizar maestro: $errorMessage',
        );
      } else {
        return ResponseHandler.handleFailure<bool>(e);
      }
    }
  }
}
