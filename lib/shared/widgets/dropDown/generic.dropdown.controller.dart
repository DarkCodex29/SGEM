import 'dart:developer';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/option.value.dart';

class GenericDropdownController extends GetxController {
  var isLoadingMap = <String, RxBool>{}.obs;
  var optionsMap = <String, RxList<OptionValue>>{}.obs;
  var selectedValueMap = <String, Rxn<OptionValue>>{}.obs;

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
  // Future<void> loadOptions(
  //     String key, Future<List<OptionValue>> Function() getOptions) async {
  //   initializeDropdown(key);
  //   isLoadingMap[key]!.value = true;
  //   try {
  //     var loadedOptions = await getOptions();
  //     optionsMap[key]!.assignAll(loadedOptions);
  //   } catch (e) {
  //     log('Error loading options for $key: $e');
  //   } finally {
  //     isLoadingMap[key]!.value = false;
  //   }
  // }
  Future<void> loadOptions(
      String key, Future<List<OptionValue>> Function() getOptions) async {
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

  void selectValue(String key, OptionValue? value) {
    selectedValueMap[key]?.value = value;
  }

  void resetSelection(String key) {
    selectedValueMap[key]?.value = null;
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


