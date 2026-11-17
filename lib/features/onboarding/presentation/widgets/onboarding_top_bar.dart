import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/step_indicator.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Back button + step dots. The trailing spacer keeps the dots centred.
class OnboardingTopBar extends StatelessWidget {
  final int step;

  const OnboardingTopBar({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: S.of(context).back,
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.textPrimary(context),
          style: IconButton.styleFrom(minimumSize: const Size.square(48)),
        ),
        StepIndicator(step: step),
        const SizedBox.square(dimension: 48),
      ],
    );
  }
}
