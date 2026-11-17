import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Labelled single-line field with the design's focus ring.
/// Owns its controller; seed it with [initialValue].
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.initialValue = '',
    this.textInputAction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
        borderRadius: AppRadius.control,
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.label14
              .copyWith(color: AppColors.textPrimary(context)),
        ),
        const SizedBox(height: AppSpacing.xxs),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.control,
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: AppColors.primarySoft(context),
                      spreadRadius: AppSpacing.xxs,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyles.body16
                .copyWith(color: AppColors.textPrimary(context)),
            cursorColor: AppColors.primary(context),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.body16
                  .copyWith(color: AppColors.textMuted(context)),
              filled: true,
              fillColor: AppColors.surface(context),
              isDense: true,
              constraints: const BoxConstraints(minHeight: 52),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              enabledBorder: _border(AppColors.border(context), 1.5),
              focusedBorder: _border(AppColors.primary(context), 2),
            ),
          ),
        ),
      ],
    );
  }
}
