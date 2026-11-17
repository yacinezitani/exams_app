import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Home · Decks · Stats · Settings. Built on [NavigationBar] for semantics,
/// selected state and 48 px targets.
class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final selectedColor = AppColors.primary(context);
    final idleColor = AppColors.weekday(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 68,
          backgroundColor: AppColors.surface(context),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.primarySoft(context),
          indicatorShape: const StadiumBorder(),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppTextStyles.navLabelSelected12.copyWith(color: selectedColor)
                : AppTextStyles.navLabel12.copyWith(color: idleColor),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              size: 24,
              color: states.contains(WidgetState.selected) ? selectedColor : idleColor,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_rounded), label: l10n.navHome),
            NavigationDestination(icon: const Icon(Icons.style_rounded), label: l10n.navDecks),
            NavigationDestination(icon: const Icon(Icons.bar_chart_rounded), label: l10n.navStats),
            NavigationDestination(icon: const Icon(Icons.tune_rounded), label: l10n.navSettings),
          ],
        ),
      ),
    );
  }
}
