import 'dart:developer';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';

class ResponseHandler<T> {
  final T? data;
  final bool success;
  final String? message;

  ResponseHandler({
    required this.success,
    this.data,
    this.message,
  });

  static ResponseHandler<T> handleSuccess<T>(dynamic response) {
    // Caso 1: Booleano
    if (response is bool) {
      log('Operación booleana exitosa');
      return ResponseHandler<T>(success: response, data: response as T);
    }

    // Caso 2: Formato con 'Codigo' y 'Valor'
    if (response is Map<String, dynamic> &&
        response.containsKey('Codigo') &&
        response.containsKey('Valor')) {
      if (response['Codigo'] == 200 && response['Valor'] == 'OK') {
        log('Operación exitosa con Codigo y Valor');
        return ResponseHandler<T>(success: true, data: response as T);
      } else {
        return ResponseHandler<T>(
          success: false,
          message: response['Message'] ?? 'Error desconocido',
        );
      }
    }

    // Caso 3: Lista de Maestros, Maestros Detalles o Personal
    if (response is List) {
      log('Respuesta exitosa con datos de lista');
      return ResponseHandler<T>(success: true, data: response as T);
    }

    // Caso 4: Mapa genérico
    if (response is Map<String, dynamic>) {
      log('Respuesta exitosa con datos de mapa');
      if (T == Personal) {
        try {
          final personal = Personal.fromJson(response);
          return ResponseHandler<T>(success: true, data: personal as T);
        } catch (e) {
          log('Error al mapear la respuesta a Personal: $e');
          return ResponseHandler<T>(
            success: false,
            message: 'Error al mapear la respuesta a Personal.',
          );
        }
      }
      if (T == EntrenamientoModulo) {
        try {
          final entrenamientoModulo = EntrenamientoModulo.fromJson(response);
          return ResponseHandler<T>(
              success: true, data: entrenamientoModulo as T);
        } catch (e) {
          log('Error al mapear la respuesta a EntrenamientoModulo: $e');
          return ResponseHandler<T>(
            success: false,
            message: 'Error al mapear la respuesta a EntrenamientoModulo.',
          );
        }
      }
      return ResponseHandler<T>(success: true, data: response as T);
    }

    // Caso no esperado
    return ResponseHandler<T>(
      success: false,
      message: 'Formato de respuesta no esperado',
    );
  }

  static ResponseHandler<T> handleFailure<T>(dynamic error) {
    if (error?.response?.data != null &&
        error.response?.data['Message'] != null) {
      var errorMessage = error.response.data['Message'];
      log('Error: $errorMessage');
      return ResponseHandler<T>(
        success: false,
        message: errorMessage,
      );
    } else {
      return ResponseHandler<T>(
        success: false,
        message: error?.message ?? 'Error desconocido',
      );
    }
  }
}

class ErrorHandler {
  final String message;

  ErrorHandler(this.message);

  @override
  String toString() {
    return message;
  }
}
