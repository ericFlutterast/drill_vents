import 'package:equatable/equatable.dart';

enum StateStatus { idle, pending, refreshing, pagination, error, done }

class CommonBlocState<T> extends Equatable {
  const CommonBlocState({T? value, Object? error, required StateStatus status})
    : _value = value,
      _error = error,
      _status = status;

  final T? _value;
  // TODO: нада подумать над этим, не очень удобно выводить ошибку на экране если она не стринга или не кастом объект
  final Object? _error;
  final StateStatus _status;

  const CommonBlocState.init({T? value}) : _value = value, _error = null, _status = StateStatus.idle;

  T get value => _value!;
  T? get getValueOrNull => _value;
  Object get errorMessage => _error ?? 'Ошибка';
  Object? get errorMessageOrNull => _error;
  StateStatus get status => _status;

  bool get hasValue => _value != null;
  bool get hasError => _error != null;

  bool get isIdle => status == StateStatus.idle;
  bool get isPending => status == StateStatus.pending;
  bool get isRefreshing => status == StateStatus.refreshing;
  bool get isPagination => status == StateStatus.pagination;
  bool get isError => status == StateStatus.error;
  bool get isDone => status == StateStatus.done;

  CommonBlocState<T> idle({T? value}) => CommonBlocState<T>(status: StateStatus.idle, value: value);
  CommonBlocState<T> pending({T? value}) => CommonBlocState<T>(status: StateStatus.pending, value: value);
  CommonBlocState<T> refreshing() => CommonBlocState<T>(status: StateStatus.refreshing);
  CommonBlocState<T> pagination({T? value}) => CommonBlocState<T>(value: value, status: StateStatus.pagination);
  CommonBlocState<T> error(Object error, {T? value}) =>
      CommonBlocState<T>(status: StateStatus.error, error: error, value: value);
  CommonBlocState<T> done(T? value) => CommonBlocState<T>(status: StateStatus.done, value: value);

  @override
  List<Object?> get props => [_value, _error, _status];

  CommonBlocState<T> copyWith({T? value, Object? error, StateStatus? status}) =>
      CommonBlocState<T>(status: status ?? this.status, value: value ?? this.value, error: error ?? this.error);
}
