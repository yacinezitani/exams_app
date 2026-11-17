part of 'home_cubit.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  final HomeData data;
  const HomeSuccess(this.data);
}

final class HomeFailure extends HomeState {
  final String errMessage;
  const HomeFailure(this.errMessage);
}
