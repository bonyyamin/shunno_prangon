abstract class Result<T, E> {
  factory Result.success(T value) = Success<T, E>;
  factory Result.error(E error) = Error<T, E>;

  bool get isSuccess;
  bool get isError;

  T get asSuccess;
  E get asError;
}

class Success<T, E> implements Result<T, E> {

  Success(this.value);
  final T value;

  @override
  bool get isSuccess => true;

  @override
  bool get isError => false;

  @override
  T get asSuccess => value;

  @override
  E get asError => throw StateError('Cannot get error from a success result.');
}

class Error<T, E> implements Result<T, E> {

  Error(this.error);
  final E error;

  @override
  bool get isSuccess => false;

  @override
  bool get isError => true;

  @override
  T get asSuccess => throw StateError('Cannot get value from an error result.');

  @override
  E get asError => error;
}
