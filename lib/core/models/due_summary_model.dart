import 'package:flutter/foundation.dart';

@immutable
class DueSummaryModel {
  /// Due cards that have been studied before.
  final int reviewCount;

  /// Due cards never studied.
  final int newCount;

  const DueSummaryModel({this.reviewCount = 0, this.newCount = 0});

  int get total => reviewCount + newCount;
}
