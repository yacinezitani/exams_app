import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/models/settings_model.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _repo;

  SettingsCubit(this._repo) : super(const SettingsInitial());

  Future<void> load() async {
    if (isClosed) return;
    // Reloads stay silent so the router never sees a transient non-success state.
    if (state is SettingsInitial) emit(const SettingsLoading());

    final result = await _repo.getSettings();
    if (isClosed) return;

    result.fold(
      (settings) => emit(SettingsSuccess(settings)),
      (failure) => emit(SettingsFailure(failure.error)),
    );
  }
}
