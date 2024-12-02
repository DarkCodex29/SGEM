import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    required this.dropdownKey,
    required this.label,
    this.options,
    this.isRequired = false,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.initialValue,
    this.onChanged,
    this.paddingLeft,
    super.key,
  });

  final String dropdownKey;
  final List<OptionValue>? options;
  final bool isRequired;
  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;
  final double? paddingLeft;
  final void Function(int?)? onChanged;

  final int? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GenericDropdownController>();
    final cached = options == null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    var options = this.options;
                    if (cached) {
                      options = controller.getOptionsFromKey(dropdownKey);
                      final isLoading = controller.isLoading(dropdownKey);

                      if (isLoading) {
                        return const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }

                    final int? value;
                    if (options?.isEmpty ?? true) {
                      value = null;
                    } else {
                      value = initialValue ??
                          controller.getSelectedValue(dropdownKey)?.key;
                    }

                    return _Dropdown(
                      options: options!,
                      dropdownKey: dropdownKey,
                      value: value,
                      label: label,
                      readOnly: readOnly,
                      hint: hint,
                      disabledHint: disabledHint,
                      // onChanged: (_) {},
                      onChanged: onChanged != null
                          ? onChanged
                          : cached
                              ? (value) {
                                  if (value == null) {
                                    controller.resetSelection(dropdownKey);
                                  } else {
                                    controller.selectValueByKey(
                                      options: dropdownKey,
                                      optionKey: value,
                                    );
                                  }
                                }
                              : (value) {
                                  if (value == null) {
                                    controller.resetSelection(dropdownKey);
                                  } else {
                                    controller.selectValue(
                                      dropdownKey,
                                      options!
                                          .firstWhere((e) => e.key == value),
                                    );
                                  }
                                },
                    );
                  },
                ),
                // Si staticOptions está presente, mostramos sin Obx
                // if (isSearchable && !readOnly) _buildSearchBar(),
              ],
            ),
          ),
          if (isRequired)
            Padding(
              padding: EdgeInsets.only(left: paddingLeft ?? 6, bottom: 16),
              child: const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.options,
    required this.dropdownKey,
    required this.value,
    required this.label,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.onChanged,
  });

  final List<OptionValue> options;
  final String dropdownKey;
  final int? value;
  final void Function(int?)? onChanged;

  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    Logger('Dropdown').info('Building dropdown $dropdownKey');

    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      hint: hint != null
          ? Text(
              hint!,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 16,
              ),
            )
          : null,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.alternateColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.alternateColor,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onChanged: readOnly ? null : onChanged,
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option.key,
              child: Text(option.nombre ?? 'N/A'),
            ),
          )
          .toList(),
      disabledHint: disabledHint != null
          ? Text(
              // initialValue?.nombre ?? hintText,
              disabledHint!,
              style: const TextStyle(color: Colors.grey),
            )
          : null,
    );
  }
}
