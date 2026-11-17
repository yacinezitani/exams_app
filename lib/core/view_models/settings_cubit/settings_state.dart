part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsSuccess extends SettingsState {
  final SettingsModel settings;
  const SettingsSuccess(this.settings);
}

final class SettingsFailure extends SettingsState {
  final String errMessage;
  const SettingsFailure(this.errMessage);
}
