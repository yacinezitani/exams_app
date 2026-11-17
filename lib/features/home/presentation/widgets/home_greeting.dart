import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/date_labels.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Date line + time-of-day greeting. [welcome] swaps in "Welcome" (first run,
/// no decks yet).
class HomeGreeting extends StatelessWidget {
  final DateTime now;
  final String? userName;
  final bool welcome;

  const HomeGreeting({
    super.key,
    required this.now,
    required this.userName,
    this.welcome = false,
  });

  String _greeting(S l10n) {
    final name = userName;
    final hasName = name != null && name.isNotEmpty;
    if (welcome) return hasName ? l10n.homeWelcomeNamed(name) : l10n.homeWelcome;
    final base = switch (now.hour) {
      < 12 => l10n.greetingMorning,
      < 18 => l10n.greetingAfternoon,
      _ => l10n.greetingEvening,
    };
    return hasName ? l10n.greetingWithName(base, name) : base;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeDate(
            DateLabels.weekdayName(locale, now),
            DateLabels.dayMonthLong(locale, now),
          ),
          style: AppTextStyles.date14.copyWith(color: AppColors.textMuted(context)),
        ),
        const SizedBox(height: AppSpacing.xxs / 2),
        Text(
          _greeting(l10n),
          style: AppTextStyles.greeting24.copyWith(color: AppColors.textPrimary(context)),
        ),
      ],
    );
  }
}
