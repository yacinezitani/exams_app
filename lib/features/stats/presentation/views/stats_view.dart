import 'package:exam_app/core/widgets/coming_soon_body.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder until this screen is built.
class StatsView extends StatelessWidget {
  static const String routeName = '/stats';

  const StatsView({super.key});

  @override
  Widget build(BuildContext context) =>
      ComingSoonBody(title: S.of(context).navStats);
}
