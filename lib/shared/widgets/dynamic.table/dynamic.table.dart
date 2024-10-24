import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sgem/shared/widgets/dynamic.table/dynamic.table.controller.dart';

class DynamicTable<T> extends StatelessWidget {

  final List<dynamic> data;
  final List<Widget> celdas;
  final DynamicTableController<T>? controller;

  const DynamicTable({
    super.key,
//    required this.cabecera,
    required this.data,
    required this.celdas,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //final DynamicTableController controller = Get.put(DynamicTableController());

    return Column(
      children: [
       // _buildCabecera(cabecera),
        _buildTablaData(data),
      ],
    );
  }

  Widget _buildCabecera(List<String> cabecera) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: cabecera.map((header) {
          return Expanded(
            flex: 1,
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTablaData(
      List<dynamic> data) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: data.map((fila) {
            return _buildFila(celdas);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFila(List<Widget> celdas) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: celdas.map((celda) {
          return Expanded(flex: 1, child: celda);
        }).toList(),
      ),
    );
  }
}
