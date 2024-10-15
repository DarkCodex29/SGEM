import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

class CustomDropdown extends StatefulWidget {
  final String hintText;
  final List<String> options;
  final bool isSearchable;
  final String? selectedValue;
  final Function(String?) onChanged;
  final bool isRequired;
  final bool isReadOnly;

  const CustomDropdown({
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    this.isSearchable = false,
    this.isRequired = false,
    this.isReadOnly = false,
    super.key,
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  List<String> filteredOptions = [];

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
                  child: DropdownButtonFormField<String>(
                    value: widget.selectedValue,
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
                    onChanged: widget.isReadOnly
                        ? null
                        : (value) {
                            widget.onChanged(value);
                          },
                    items: filteredOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    disabledHint: Text(
                      widget.selectedValue ?? widget.hintText,
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
                    option.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }
}


abstract class DropdownElement {
  // Definición de una interfaz implícita
  String get value;
  int get id;

  @override
  String toString() {
    // TODO: implement toString
    return value;
  }
  
}

class Binding<T> {
  final void Function(T?) set;
  final T? Function() get;

  const Binding({
    required this.set,
    required this.get
  });

}

class CustomGenericDropdown<Element extends DropdownElement> extends StatefulWidget {
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

class CustomGenericDropdownState<Element extends DropdownElement> extends State<CustomGenericDropdown<Element>> {
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
                    onChanged: (option) => {
                      widget.selectedValue.set(option)
                    },
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