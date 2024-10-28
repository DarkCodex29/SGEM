import 'dart:developer';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/option.value.dart';

class GenericDropdownController extends GetxController {
  final isLoadingMap = <String, RxBool>{};
  final optionsMap = <String, RxList<OptionValue>>{};
  final selectedValueMap = <String, Rxn<OptionValue>>{};
  RxInt? selectedValueKey = 0.obs;

  void initializeDropdown(String key) {
    if (!isLoadingMap.containsKey(key)) {
      isLoadingMap[key] = false.obs;
    }
    if (!optionsMap.containsKey(key)) {
      optionsMap[key] = <OptionValue>[].obs;
    }
    if (!selectedValueMap.containsKey(key)) {
      selectedValueMap[key] = Rxn<OptionValue>();
    }
  }

  Future<void> loadOptions(
      String key, Future<List<OptionValue>?> Function() getOptions) async {
    initializeDropdown(key);

   //if (isLoadingMap[key]!.value) return; // Previene cargas duplicadas

   // isLoadingMap[key]!.value = true;
    try {
      var loadedOptions = await getOptions() ?? [];
      optionsMap[key]?.assignAll(loadedOptions);
    } catch (e) {
      log('Error loading options for $key: $e');
    } finally {
      isLoadingMap[key]?.value = false;
    }
  }

  void selectValue(String key, OptionValue? value) {
    if (selectedValueMap.containsKey(key)) {
      selectedValueMap[key]!.value = value;
      selectedValueKey?.value = value?.key ?? 0;
    }
  }

  void selectValueKey(String key, int? value) {
    if (selectedValueMap.containsKey(key) && value != null) {
      selectedValueKey?.value = value;
      var matchingOption = optionsMap[key]?.firstWhere(
          (option) => option.key == value,
          orElse: () => OptionValue(key: value, nombre: "No encontrado"));
      selectedValueMap[key]!.value = matchingOption;
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
  List<OptionValue> getOptions(String key) => optionsMap[key]?.toList() ?? [];
  OptionValue? getSelectedValue(String key) => selectedValueMap[key]?.value;
}
