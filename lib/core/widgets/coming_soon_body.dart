import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Stand-in for screens that are not built yet. Shows a back button when the
/// screen was pushed on top of another.
class ComingSoonBody extends StatelessWidget {
  final String title;

  const ComingSoonBody({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.canPop())
                IconButton(
                  tooltip: S.of(context).back,
                  onPressed: context.pop,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: AppColors.textPrimary(context),
                  style: IconButton.styleFrom(minimumSize: const Size.square(48)),
                )
              else
                const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.heading26
                    .copyWith(color: AppColors.textPrimary(context)),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    S.of(context).comingSoon,
                    style: AppTextStyles.body16
                        .copyWith(color: AppColors.textMuted(context)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
