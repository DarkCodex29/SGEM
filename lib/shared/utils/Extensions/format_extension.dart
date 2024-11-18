import 'package:intl/intl.dart';

final _numberFormat = NumberFormat('000');
final _dateFormat = DateFormat('dd/MM/yyyy');
final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

extension NumberFormatX on num {
  String get format => _numberFormat.format(this);
}

extension DateTimeFormatX on DateTime {
  String get format => _dateFormat.format(this);
  String get formatExtended => _dateTimeFormat.format(this);
}
