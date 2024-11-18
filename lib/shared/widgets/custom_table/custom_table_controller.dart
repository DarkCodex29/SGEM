part of 'custom_table.dart';

class CustomTableController<T> extends GetxController {
  CustomTableController({
    required List<T> data,
    int? totalRecords,
  })  : _data = RxList<T>(data),
        _totalRecords = totalRecords;

  final RxList<T> _data;
  List<T> get data => _data
      .skip(
        rowsPerPage.value * (currentPage.value - 1),
      )
      .take(rowsPerPage.value)
      .toList();
  set data(List<T> value) => _data.assignAll(value);

  int get totalPages => (totalRecords / rowsPerPage.value).ceil();
  int get totalRecords => _totalRecords ?? _data.length;
  final int? _totalRecords;

  int get infLimit => (currentPage.value - 1) * rowsPerPage.value + 1;
  int get supLimit {
    final val = currentPage.value * rowsPerPage.value;
    return val > totalRecords ? totalRecords : val;
  }

  final rowsPerPage = 5.obs;
  final currentPage = 1.obs;

  void changeRowsPerPage(int value) {
    rowsPerPage.value = value;
    currentPage.value = 1;
  }
}
