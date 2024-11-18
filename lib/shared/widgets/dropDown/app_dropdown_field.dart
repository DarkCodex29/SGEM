import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class AppDropdownField extends StatefulWidget {
  const AppDropdownField({
    required this.dropdownKey,
    required this.label,
    this.options,
    this.isRequired = false,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.initialValue,
    super.key,
  });

  final String dropdownKey;
  final List<OptionValue>? options;
  final bool isRequired;
  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;

  final int? initialValue;

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  late final GenericDropdownController controller;

  @override
  void initState() {
    controller = Get.find<GenericDropdownController>();
    controller.initializeDropdown(widget.dropdownKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cached = widget.options == null;

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
                    final value = widget.initialValue ??
                        controller.getSelectedValue(widget.dropdownKey)?.key;
                    var options = this.widget.options;

                    if (cached) {
                      options =
                          controller.getOptionsFromKey(widget.dropdownKey);
                      final isLoading =
                          controller.isLoading(widget.dropdownKey);

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

                    return _Dropdown(
                      options: options!,
                      dropdownKey: widget.dropdownKey,
                      value: value,
                      label: widget.label,
                      readOnly: widget.readOnly,
                      hint: widget.hint,
                      disabledHint: widget.disabledHint,
                      // onChanged: (_) {},
                      onChanged: cached
                          ? (value) {
                              if (value == null) {
                                controller.resetSelection(widget.dropdownKey);
                              } else {
                                controller.selectValueByKey(
                                  options: widget.dropdownKey,
                                  optionKey: value,
                                );
                              }
                            }
                          : (value) {
                              if (value == null) {
                                controller.resetSelection(widget.dropdownKey);
                              } else {
                                controller.selectValue(
                                  widget.dropdownKey,
                                  options!.firstWhere((e) => e.key == value),
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
          if (widget.isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 16),
              child: Text(
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
    debugPrint('Building Dropdown $dropdownKey');

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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
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
