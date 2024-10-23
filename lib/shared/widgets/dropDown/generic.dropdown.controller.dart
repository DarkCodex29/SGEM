import 'dart:developer';
import 'package:get/get.dart';

class GenericDropdownController<T> extends GetxController {
  var isLoadingMap = <String, RxBool>{}.obs;
  var optionsMap = <String, RxList<T>>{}.obs;
  var selectedValueMap = <String, Rxn<T>>{}.obs;

  void initializeDropdown(String key) {
    if (!isLoadingMap.containsKey(key)) {
      isLoadingMap[key] = false.obs;
      optionsMap[key] = <T>[].obs;
      selectedValueMap[key] = Rxn<T>();
    }
  }

  Future<void> loadOptions(
      String key, Future<List<T>> Function() getOptions) async {
    initializeDropdown(key);
    isLoadingMap[key]!.value = true;
    try {
      var loadedOptions = await getOptions();
      optionsMap[key]!.assignAll(loadedOptions);
    } catch (e) {
      log('Error loading options for $key: $e');
    } finally {
      isLoadingMap[key]!.value = false;
    }
  }

  void selectValue(String key, T? value) {
    selectedValueMap[key]?.value = value;
  }

  bool isLoading(String key) => isLoadingMap[key]?.value ?? false;
  List<T> getOptions(String key) => optionsMap[key]?.toList() ?? [];
  T? getSelectedValue(String key) => selectedValueMap[key]?.value;
}
