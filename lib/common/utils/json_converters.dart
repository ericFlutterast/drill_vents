import 'package:drill_events/common/utils/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

final class ToRFC3337DateConverter implements JsonConverter<DateTime, String> {
  const ToRFC3337DateConverter();

  @override
  fromJson(json) => DateTime.parse(json);

  @override
  toJson(object) => object.toRFC3337Date();
}

final class ToRFC3337TimeConverter implements JsonConverter<DateTime, String> {
  const ToRFC3337TimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toRFC3337Time();
}
