import 'package:exam_app/core/di/injection.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      // The bottom nav (in the shell) owns the bottom inset.
      child: const Scaffold(body: SafeArea(bottom: false, child: HomeViewBody())),
    );
  }
}
