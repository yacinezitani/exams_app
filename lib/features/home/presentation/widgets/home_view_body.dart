import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/core/widgets/error_state.dart';
import 'package:exam_app/core/widgets/list_skeleton.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/widgets/home_content.dart';
import 'package:exam_app/features/home/presentation/widgets/home_empty_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Exam name/date/goal live in settings: refresh when they change.
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, _) => context.read<HomeCubit>().load(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => switch (state) {
          HomeInitial() || HomeLoading() => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: SingleChildScrollView(child: ListSkeleton()),
            ),
          HomeFailure() => ErrorState(onRetry: context.read<HomeCubit>().load),
          HomeSuccess(:final data) =>
            data.isEmpty ? HomeEmptyContent(data: data) : HomeContent(data: data),
        },
      ),
    );
  }
}
