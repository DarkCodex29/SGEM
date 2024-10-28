import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class CustomDropdown extends StatelessWidget {
  final String dropdownKey;
  final String hintText;
  final String noDataHintText;
  final bool isSearchable;
  final bool isRequired;
  final bool isReadOnly;
  final GenericDropdownController? controller;
  final List<OptionValue>? staticOptions;
  final OptionValue? initialValue;
  final void Function(OptionValue?)? onChanged;

  const CustomDropdown({
    required this.dropdownKey,
    required this.hintText,
    required this.noDataHintText,
    this.controller,
    this.staticOptions,
    this.initialValue,
    this.onChanged,
    this.isSearchable = false,
    this.isRequired = false,
    this.isReadOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller != null && staticOptions == null)
                  Obx(() {
                    var options = controller!.getOptions(dropdownKey);
                    var isLoading = controller!.isLoading(dropdownKey);

                    if (isLoading) {
                      return const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return _buildDropdown(options);
                  })
                else if (staticOptions != null)
                  _buildDropdown(staticOptions!)
                else
                  const Text("Error: No controller or static options provided"),
                if (isSearchable && !isReadOnly) _buildSearchBar(),
              ],
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 16),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<OptionValue> options) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField<OptionValue>(
        value: initialValue ?? controller?.getSelectedValue(dropdownKey),
        isExpanded: true,
        hint: Text(
          options.isEmpty ? noDataHintText : hintText,
          style: const TextStyle(
            color: AppTheme.primaryText,
            fontSize: 16,
          ),
        ),
        decoration: InputDecoration(
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
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 12.0,
          ),
        ),
        onChanged: isReadOnly || options.isEmpty
            ? null
            : (value) {
                if (controller != null) {
                  controller!.selectValue(dropdownKey, value);
                }
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
        items: options.map((option) {
          return DropdownMenuItem<OptionValue>(
            value: option,
            child: Text(option.nombre ?? ''),
          );
        }).toList(),
        disabledHint: Text(
          initialValue?.nombre ??
              controller?.getSelectedValue(dropdownKey)?.nombre ??
              hintText,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          border: OutlineInputBorder(),
        ),
        onChanged: (query) {
          var options = (staticOptions ?? controller!.getOptions(dropdownKey))
              .where((option) =>
                  option.nombre?.toLowerCase().contains(query.toLowerCase()) ??
                  false)
              .toList();
          if (controller != null) {
            controller!.optionsMap[dropdownKey]?.assignAll(options);
          }
        },
      ),
    );
  }
}

abstract class DropdownElement {
  // Definición de una interfaz implícita
  String get value;
  int? get id;

  @override
  String toString() {
    // TODO: implement toString
    return value;
  }
}

class Binding<T> {
  final void Function(T?) set;
  final T? Function() get;

  const Binding({required this.set, required this.get});
}

class CustomGenericDropdown<Element extends DropdownElement>
    extends StatefulWidget {
  final String hintText;
  final List<Element> options;
  final bool isSearchable;
  final Binding<Element> selectedValue;
  final bool isRequired;
  final bool isReadOnly;

  const CustomGenericDropdown({
    required this.hintText,
    required this.options,
    required this.selectedValue,
    this.isSearchable = false,
    this.isRequired = false,
    this.isReadOnly = false,
    super.key,
  });

  @override
  CustomGenericDropdownState createState() => CustomGenericDropdownState();
}

class CustomGenericDropdownState<Element extends DropdownElement>
    extends State<CustomGenericDropdown<Element>> {
  List<Element> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: DropdownButtonFormField<Element>(
                    value: widget.selectedValue.get(),
                    isExpanded: true,
                    hint: Text(
                      widget.hintText,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 16,
                      ),
                    ),
                    decoration: InputDecoration(
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
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 12.0,
                      ),
                    ),
                    onChanged: (option) => {widget.selectedValue.set(option)},
                    items: filteredOptions.map((Element option) {
                      return DropdownMenuItem<Element>(
                        value: option,
                        child: Text(option.value),
                      );
                    }).toList(),
                    disabledHint: Text(
                      widget.selectedValue.get()?.value ?? widget.hintText,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                if (widget.isSearchable && !widget.isReadOnly)
                  _buildSearchBar(),
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
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          border: OutlineInputBorder(),
        ),
        onChanged: (query) {
          setState(() {
            filteredOptions = widget.options
                .where((option) =>
                    option.value.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }
}
