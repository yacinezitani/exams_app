import 'package:exam_app/core/errors/failures.dart';

sealed class Result<T, E> {
  const Result();
}

final class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

final class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
}

extension ResultExtension<T, E> on Result<T, E> {
  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull => switch (this) {
        Ok(:final value) => value,
        _ => null,
      };
  E? get errorOrNull => switch (this) {
        Err(:final error) => error,
        _ => null,
      };

  R fold<R>(R Function(T value) onOk, R Function(E error) onErr) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final error) => onErr(error),
      };
}

/// Standard async result for data layer methods that return a value.
typedef FutureResult<T> = Future<Result<T, Failure>>;

/// Standard async result for data layer methods that return nothing.
typedef FutureResultVoid = Future<Result<void, Failure>>;
