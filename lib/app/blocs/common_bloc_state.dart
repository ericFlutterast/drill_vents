import 'package:equatable/equatable.dart';

enum StateStatus { idle, loading, refreshing, pagination, error, done }

class CommonBlocState<T> extends Equatable {
  const CommonBlocState({T? value, Object? error, required StateStatus status})
    : _value = value,
      _error = error,
      _status = status;

  final T? _value;
  final Object? _error;
  final StateStatus _status;

  const CommonBlocState.init() : _value = null, _error = null, _status = StateStatus.idle;

  T get value => _value!;
  T? get getValueOrNull => _value;
  Object get errorMessage => _error!;
  Object? get errorMessageOrNull => _error;
  StateStatus get status => _status;

  bool get hasValue => _value != null;
  bool get hasError => _error != null;

  bool get isIdle => status == StateStatus.idle;
  bool get isPending => status == StateStatus.loading;
  bool get isRefreshing => status == StateStatus.refreshing;
  bool get isPagination => status == StateStatus.pagination;
  bool get isError => status == StateStatus.error;
  bool get isDone => status == StateStatus.done;

  CommonBlocState<T> idle() => CommonBlocState<T>(status: StateStatus.idle);
  CommonBlocState<T> pending() => CommonBlocState<T>(status: StateStatus.loading);
  CommonBlocState<T> refreshing() => CommonBlocState<T>(status: StateStatus.refreshing);
  CommonBlocState<T> pagination() => CommonBlocState<T>(status: StateStatus.pagination);
  CommonBlocState<T> error(Object error, {T? value}) =>
      CommonBlocState<T>(status: StateStatus.error, error: error, value: value);
  CommonBlocState<T> done(T? value) => CommonBlocState<T>(status: StateStatus.done, value: value);

  @override
  List<Object?> get props => [_value, _error, _status];
}
