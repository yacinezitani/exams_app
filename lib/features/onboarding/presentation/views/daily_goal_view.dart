import 'package:exam_app/features/onboarding/presentation/widgets/daily_goal_view_body.dart';
import 'package:flutter/material.dart';

class DailyGoalView extends StatelessWidget {
  static const String routeName = '/onboarding/goal';

  const DailyGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: DailyGoalViewBody()));
  }
}
