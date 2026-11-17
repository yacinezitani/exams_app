import 'package:exam_app/features/onboarding/presentation/widgets/exam_setup_view_body.dart';
import 'package:flutter/material.dart';

class ExamSetupView extends StatelessWidget {
  static const String routeName = '/onboarding/exam';

  const ExamSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: ExamSetupViewBody()));
  }
}
