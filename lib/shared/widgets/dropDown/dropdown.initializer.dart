import 'dart:developer';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class DropdownDataInitializer {
  final GenericDropdownController? dropdownController;
  final MaestroDetalleService? maestroDetalleService;
  final ModuloMaestroService? moduloMaestroService;
  final PersonalService? personalService;

  DropdownDataInitializer({
    this.dropdownController,
    this.maestroDetalleService,
    this.moduloMaestroService,
    this.personalService,
  });

  /// Método que inicializa la carga de todos los dropdowns
  Future<void> initializeAllDropdowns() async {
    await Future.wait([
      _loadEstado(),
      _loadGuardiaFiltro(),
      _loadGuardiaRegistro(),
      _loadEquipo(),
      _loadModulo(),
      _loadCategoria(),
      loadEmpresaCapacitacion(),
      _loadCapacitacion(),
      _loadEntrenador(),
      _loadEstadoEntrenamiento(),
      _loadCondicion(),
      _loadEstadoModulo(),
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

  Future<void> _loadEstado() async {
    dropdownController!.initializeDropdown('estado');
    dropdownController!.optionsMap['estado']?.addAll([
      OptionValue(key: 0, nombre: 'Todos'),
      OptionValue(key: 95, nombre: 'Activo'),
      OptionValue(key: 96, nombre: 'Cesado'),
    ]);
    log('Estado cargado');
  }

  /// Métodos de carga específicos para cada dropdown, utilizando el servicio correcto

  Future<void> _loadGuardiaFiltro() async {
    await dropdownController!.loadOptions('guardiaFiltro', () async {
      var options = await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(2),
      );
      options.insert(0, OptionValue(key: 0, nombre: 'Todos'));
      return options;
    });
    log('Guardia cargada');
  }

  Future<void> _loadGuardiaRegistro() async {
    await dropdownController!.loadOptions('guardiaRegistro', () async {
      var options = await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(2),
      );
      return options;
    });
    log('Guardia cargada');
  }

  Future<void> _loadEquipo() async {
    await dropdownController!.loadOptions('equipo', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(5),
      );
    });
    log('Equipo cargado');
  }

  Future<void> _loadModulo() async {
    await dropdownController!.loadOptions('modulo', () async {
      return await _handleResponse(
        moduloMaestroService!.listarMaestros(),
      );
    });
    log('Modulo cargado');
  }

  Future<void> _loadCategoria() async {
    await dropdownController!.loadOptions('categoria', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(9),
      );
    });
    log('Categoria cargada');
  }

  Future<void> loadEmpresaCapacitacion({bool filtrarExterna = false}) async {
    await dropdownController!.loadOptions('empresaCapacitacion', () async {
      var options = await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(8),
      );
      if (filtrarExterna) {
        options =
            options.where((empresa) => empresa.nombre != 'Entrenamiento mina').toList();
      }

      return options;
    });
    log('Opciones cargadas para empresaCapacitacion: ${dropdownController!.getOptionsFromKey('empresaCapacitacion').map((e) => e.nombre)}');
  }

  Future<void> _loadCapacitacion() async {
    await dropdownController!.loadOptions('capacitacion', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(7),
      );
    });
    log('Capacitación cargada');
  }

  Future<void> _loadEntrenador() async {
    await dropdownController!.loadOptions('entrenador', () async {
      return await _handleResponse(
        personalService!.listarEntrenadores(),
      );
    });
    log('Entrenador cargado');
  }

  Future<void> _loadEstadoEntrenamiento() async {
    await dropdownController!.loadOptions('estadoEntrenamiento', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(4),
      );
    });
    log('Estado de entrenamiento cargado');
  }

  Future<void> _loadCondicion() async {
    await dropdownController!.loadOptions('condicion', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(3),
      );
    });
    log('Condición cargada');
  }

  Future<void> _loadEstadoModulo() async {
    await dropdownController!.loadOptions('estadoModulo', () async {
      return await _handleResponse(
        maestroDetalleService!.listarMaestroDetallePorMaestro(10),
      );
    });
    log('Estados de módulo cargados');
  }
}
