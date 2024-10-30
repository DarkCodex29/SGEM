import 'dart:developer';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/option.value.dart';

class GenericDropdownController extends GetxController {
  var isLoadingControl = true.obs;
  final isLoadingMap = <String, RxBool>{};
  final optionsMap = <String, RxList<OptionValue>>{};
  final selectedValueMap = <String, Rxn<OptionValue>>{};
  RxInt selectedValueKey = 0.obs;

  /// Inicializa los campos del dropdown para una clave específica.
  void initializeDropdown(String key) {
    isLoadingMap.putIfAbsent(key, () => false.obs);
    optionsMap.putIfAbsent(key, () => <OptionValue>[].obs);
    selectedValueMap.putIfAbsent(key, () => Rxn<OptionValue>());
  }

  /// Carga las opciones para el dropdown, evitando duplicaciones.
  Future<void> loadOptions(
      String key, Future<List<OptionValue>?> Function() getOptions) async {
    initializeDropdown(key);
    if (isLoadingMap[key]!.value) return; // Evita cargas duplicadas.

    isLoadingMap[key]!.value = true;
    try {
      var loadedOptions = await getOptions() ?? [];
      optionsMap[key]?.assignAll(loadedOptions);
    } catch (e) {
      log('Error al cargar opciones para $key: $e');
    } finally {
      isLoadingMap[key]?.value = false;
    }
  }

  /// Establece la opción seleccionada directamente proporcionando un `OptionValue`.
  void selectValue(String key, OptionValue? value) {
    initializeDropdown(key);
    selectedValueMap[key]?.value = value;
    selectedValueKey.value = value?.key ?? 0;
  }

  /// Busca y selecciona una opción mediante su `key`, actualizando el valor seleccionado.
  void selectValueKey(String key, int? valueKey) {
    initializeDropdown(key);
    if (valueKey != null) {
      selectedValueKey.value = valueKey;
      var matchingOption = optionsMap[key]?.firstWhere(
        (option) => option.key == valueKey,
        orElse: () => OptionValue(key: valueKey, nombre: "No encontrado"),
      );
      selectedValueMap[key]?.value = matchingOption;
    }
  }

  /// Restablece la selección para una clave de dropdown específica.
  void resetSelection(String key) {
    initializeDropdown(key);
    selectedValueMap[key]?.value = null;
  }

  /// Restablece todas las selecciones de dropdown.
  void resetAllSelections() {
    selectedValueMap.forEach((key, value) => value.value = null);
  }

  /// Verifica si las opciones están cargando para un dropdown específico.
  bool isLoading(String key) => isLoadingMap[key]?.value ?? false;

  /// Obtiene la lista de opciones para un dropdown específico.
  List<OptionValue> getOptions(String key) => optionsMap[key]?.toList() ?? [];

  /// Obtiene el `OptionValue` actualmente seleccionado para una clave de dropdown.
  OptionValue? getSelectedValue(String key) => selectedValueMap[key]?.value;

  /// Método utilitario para obtener `OptionValue` por su `key` si es necesario.
  OptionValue? getSelectedValueByKey(String key, int keyToFind) {
    initializeDropdown(key);
    return optionsMap[key]?.firstWhere(
      (option) => option.key == keyToFind,
      orElse: () => OptionValue(key: keyToFind, nombre: "No encontrado"),
    );
  }

  void completeLoading() {
    isLoadingControl.value = false;
  }
}
