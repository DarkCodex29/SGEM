import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sgem/config/api/errors.dart';
import 'package:sgem/config/api/loading_interceptors.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/config/constants/const_message_response.dart';
import 'package:sgem/config/constants/enum.dart';

class ApiChinalco {
  ApiChinalco._internal();

  static final _singleton = ApiChinalco._internal();

  factory ApiChinalco() => _singleton;

  static Future<Dio> dio({
    bool loading = false,
    EnumAuthenticationRequestType authorization =
        EnumAuthenticationRequestType.none,
  }) async {
    Map<String, dynamic> mapHeader = {
      'Accept': 'application/json',
    };

    switch (authorization) {
      case EnumAuthenticationRequestType.basic:
        String username = ConfigFile.apiUsername;
        String password = ConfigFile.apiPassword;
        String basicAuth = base64.encode(utf8.encode('$username:$password'));
        mapHeader = {
          'Authorization': 'Basic $basicAuth',
        };
        break;

      case EnumAuthenticationRequestType.none:
      default:
        break;
    }

    var dio = Dio(BaseOptions(
      baseUrl: ConfigFile.apiUrl,
      contentType: 'application/json; charset=UTF-8',
      headers: mapHeader,
      receiveDataWhenStatusError: true,
    ));

    if (loading) {
      dio.interceptors.addAll({
        LoadingInterceptor(),
      });
    }

    dio.interceptors.addAll({
      AppInterceptors(dio),
    });

    return dio;
  }

  static Result<T, String> handle<T>(
    Response<dynamic> response,
    T Function(dynamic json) fromJson,
  ) {
    try {
      String message = "";
      if (response.data.runtimeType.toString().contains("Map") ||
          response.data is Map) {
        message = response.data['Message'] ?? "";
      }
      bool status = message.isEmpty;
      final data = response.data;

      return status ? Success(fromJson(data)) : Error(message);
    } catch (e) {
      return const Error(ConstMessageResponse.errorExceptionDioResponse);
    }
  }
}
