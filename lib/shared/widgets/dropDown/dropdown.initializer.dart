import 'dart:developer';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class DropdownDataInitializer {
  final GenericDropdownController dropdownController;
  final MaestroDetalleService maestroDetalleService;
  final ModuloMaestroService moduloMaestroService;
  final PersonalService personalService;

  DropdownDataInitializer({
    required this.dropdownController,
    required this.maestroDetalleService,
    required this.moduloMaestroService,
    required this.personalService,
  });

  /// Método que inicializa la carga de todos los dropdowns
  Future<void> initializeAllDropdowns() async {
    await Future.wait([
      _loadGuardia(),
      _loadEquipo(),
      _loadModulo(),
      _loadCategoria(),
      _loadEmpresaCapacitacion(),
      _loadCapacitacion(),
      _loadEntrenador(),
      _loadEstadoEntrenamiento(),
      _loadCondicion(),
    ]);
  }

  Future<List<OptionValue>> _handleResponse(Future response) async {
    var res = await response;
    if (res.success && res.data != null) {
      if (res.data is List<ModuloMaestro>) {
        return res.data!.map<OptionValue>((item) {
          return OptionValue(
            key: item.key,
            nombre: item.modulo,
          );
        }).toList();
      }
      if (res.data is List<Personal>) {
        return res.data!.map<OptionValue>((item) {
          return OptionValue(
            key: item.key,
            nombre: item.nombreCompleto,
          );
        }).toList();
      }
      return res.data!.map<OptionValue>((item) {
        return OptionValue(
          key: item.key,
          nombre: item.valor ??
              item.nombreCompleto ??
              item.modulo ??
              "No encontrado",
        );
      }).toList();
    }
    return <OptionValue>[];
  }

  /// Métodos de carga específicos para cada dropdown, utilizando el servicio correcto
  Future<void> _loadGuardia() async {
    await dropdownController.loadOptions('guardia', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(2),
      );
    });
    log('Guardia cargada');
  }

  Future<void> _loadEquipo() async {
    await dropdownController.loadOptions('equipo', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(5),
      );
    });
    log('Equipo cargado');
  }

  Future<void> _loadModulo() async {
    await dropdownController.loadOptions('modulo', () async {
      return await _handleResponse(
        moduloMaestroService.listarMaestros(),
      );
    });
    log('Modulo cargado');
  }

  Future<void> _loadCategoria() async {
    await dropdownController.loadOptions('categoria', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(9),
      );
    });
    log('Categoria cargada');
  }

  Future<void> _loadEmpresaCapacitacion() async {
    await dropdownController.loadOptions('empresaCapacitacion', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(8),
      );
    });
    log('Empresa de capacitación cargada');
  }

  Future<void> _loadCapacitacion() async {
    await dropdownController.loadOptions('capacitacion', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(7),
      );
    });
    log('Capacitación cargada');
  }

  Future<void> _loadEntrenador() async {
    await dropdownController.loadOptions('entrenador', () async {
      return await _handleResponse(
        personalService.listarEntrenadores(),
      );
    });
    log('Entrenador cargado');
  }

  Future<void> _loadEstadoEntrenamiento() async {
    await dropdownController.loadOptions('estadoEntrenamiento', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(4),
      );
    });
    log('Estado de entrenamiento cargado');
  }

  Future<void> _loadCondicion() async {
    await dropdownController.loadOptions('condicion', () async {
      return await _handleResponse(
        maestroDetalleService.listarMaestroDetallePorMaestro(3),
      );
    });
    log('Condición cargada');
  }
}
