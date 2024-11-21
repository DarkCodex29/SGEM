import 'package:json_annotation/json_annotation.dart';

class IntBoolConverter extends JsonConverter<bool, int> {
  const IntBoolConverter();

  @override
  int toJson(bool object) => object ? 1 : 0;

  @override
  bool fromJson(int json) => json == 1;
}

const intBoolConverter = IntBoolConverter();

class AjaxDateConverter implements JsonConverter<DateTime, String> {
  /// {@macro datetime_converter}
  const AjaxDateConverter();

  @override
  String toJson(DateTime object) {
    return '/Date(${object.millisecondsSinceEpoch})/';
  }

  /// string = "/Date({{ticks}})/",
  @override
  DateTime fromJson(String json) {
    if (!_regex.hasMatch(json)) {
      throw ArgumentError.value(json, 'object', 'Invalid date format');
    }

    final match = _regex.firstMatch(json)?.group(1);
    if (match == null) {
      throw ArgumentError.value(json, 'object', 'Invalid date format');
    }

    return DateTime.fromMillisecondsSinceEpoch(int.parse(match));
  }

  static final _regex = RegExp(r'/Date\((-?\d+)\)/');
}

const ajaxDateConverter = AjaxDateConverter();
