import 'package:exam_app/core/di/injection.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Hosts the one [OnboardingCubit] shared by all three steps, so answers
/// survive back navigation.
class OnboardingShell extends StatelessWidget {
  final Widget child;

  const OnboardingShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: child,
    );
  }
}
