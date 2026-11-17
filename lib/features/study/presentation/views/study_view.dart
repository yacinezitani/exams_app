import 'package:exam_app/core/widgets/coming_soon_body.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder until this screen is built.
class StudyView extends StatelessWidget {
  static const String routeName = '/study/:deckId';

  /// `deckId` value that studies every due card across decks.
  static const String allDecks = 'all';

  static String location(String deckId) => '/study/$deckId';

  final String deckId;

  const StudyView({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) =>
      ComingSoonBody(title: S.of(context).studyTitle);
}
