import 'dart:developer';
import 'package:get/get.dart';

class GenericDropdownController<T> extends GetxController {
  final isLoadingMap = <String, RxBool>{};
  final optionsMap = <String, RxList<T>>{};
  final selectedValueMap = <String, Rxn<T>>{};

  void initializeDropdown(String key) {
    if (!isLoadingMap.containsKey(key)) {
      isLoadingMap[key] = false.obs;
    }
    if (!optionsMap.containsKey(key)) {
      optionsMap[key] = <T>[].obs;
    }
    if (!selectedValueMap.containsKey(key)) {
      selectedValueMap[key] = Rxn<T>();
    }
  }

  Future<void> loadOptions(
      String key, Future<List<T>?> Function() getOptions) async {
    initializeDropdown(key);

    if (isLoadingMap[key] == null) {
      log('Error: isLoadingMap[$key] no está inicializado');
      return;
    }

    // Previene cargas duplicadas
    if (isLoadingMap[key]!.value) return;

    isLoadingMap[key]!.value = true;
    try {
      var loadedOptions = await getOptions() ?? [];
      optionsMap[key]?.assignAll(loadedOptions);
    } catch (e) {
      log('Error loading options for $key: $e');
    } finally {
      isLoadingMap[key]?.value = false;
    }
  }

  void selectValue(String key, T? value) {
    if (selectedValueMap.containsKey(key)) {
      selectedValueMap[key]!.value = value;
    }
  }

  void resetSelection(String key) {
    if (selectedValueMap.containsKey(key)) {
      selectedValueMap[key]!.value = null;
    }
  }

  void resetAllSelections() {
    selectedValueMap.forEach((key, value) {
      value.value = null;
    });
  }

  bool isLoading(String key) => isLoadingMap[key]?.value ?? false;
  List<T> getOptions(String key) => optionsMap[key]?.toList() ?? [];
  T? getSelectedValue(String key) => selectedValueMap[key]?.value;
  
}
