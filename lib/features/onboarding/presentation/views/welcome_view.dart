import 'package:exam_app/features/onboarding/presentation/widgets/welcome_view_body.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  static const String routeName = '/onboarding';

  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: WelcomeViewBody()));
  }
}
