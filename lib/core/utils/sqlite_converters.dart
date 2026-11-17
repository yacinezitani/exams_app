import 'package:json_annotation/json_annotation.dart';

/// SQLite has no bool: stored as 0/1.
class BoolIntConverter implements JsonConverter<bool, int> {
  const BoolIntConverter();

  @override
  bool fromJson(int json) => json != 0;

  @override
  int toJson(bool object) => object ? 1 : 0;
}

/// Timestamps are stored as epoch milliseconds.
class EpochMsConverter implements JsonConverter<DateTime, int> {
  const EpochMsConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
