import 'package:exam_app/core/models/deck_model.dart';
import 'package:flutter/foundation.dart';

/// A deck plus the derived counts shown on tiles. Never stored.
@immutable
class DeckSummaryModel {
  final DeckModel deck;
  final int cardCount;
  final int dueCount;
  final int masteredCount;

  const DeckSummaryModel({
    required this.deck,
    required this.cardCount,
    required this.dueCount,
    required this.masteredCount,
  });

  /// 0–1. An empty deck is 0, never NaN.
  double get mastery => cardCount == 0 ? 0 : masteredCount / cardCount;
}
