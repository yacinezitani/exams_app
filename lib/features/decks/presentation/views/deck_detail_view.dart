import 'package:exam_app/core/widgets/coming_soon_body.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder until this screen is built.
class DeckDetailView extends StatelessWidget {
  static const String routeName = '/decks/:id';

  static String location(int id) => '/decks/$id';

  final int id;

  const DeckDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) =>
      ComingSoonBody(title: S.of(context).deckDetailTitle);
}
