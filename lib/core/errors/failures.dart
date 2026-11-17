import 'package:sqflite/sqflite.dart';

sealed class Failure {
  final String error;
  const Failure(this.error);

  static Failure failureFromException(Object e) => switch (e) {
        DatabaseException() => DatabaseFailure(e.toString()),
        _ => UnknownFailure(e.toString()),
      };
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.error);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.error);
}
