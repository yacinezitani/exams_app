import 'package:exam_app/core/widgets/coming_soon_body.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder until this screen is built.
class DeckEditView extends StatelessWidget {
  static const String routeName = '/decks/edit';

  const DeckEditView({super.key});

  @override
  Widget build(BuildContext context) =>
      ComingSoonBody(title: S.of(context).deckEditTitle);
}
