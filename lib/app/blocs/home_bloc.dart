import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Event
abstract class Events {}

final class FetchEventsFeed extends Events {
  FetchEventsFeed();
}

final class SearchEvents extends Events {
  SearchEvents({required this.value});

  final String value;
}

final class PaginationEvent extends Events {}

final class EventsStateModel extends Equatable {
  const EventsStateModel({this.events = const [], this.pagination});

  final Iterable<EventCardModel> events;
  final PaginationModel? pagination;

  @override
  List<Object?> get props => [events, pagination];

  EventsStateModel copyWith({Iterable<EventCardModel>? events, PaginationModel? pagination}) =>
      EventsStateModel(events: events ?? this.events, pagination: pagination ?? this.pagination);
}

typedef EventsState = CommonBlocState<EventsStateModel>;
typedef Emit = Emitter<EventsState>;

///Bloc
final class EventsBloc extends Bloc<Events, EventsState> {
  EventsBloc(this._repository, this._logger) : super(const CommonBlocState.init(value: EventsStateModel())) {
    on<FetchEventsFeed>(_fetchFeed);
    on<SearchEvents>(_searchEvents, transformer: bloc_concurrency.restartable());
    on<PaginationEvent>(_pagination, transformer: bloc_concurrency.restartable());
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _fetchFeed(FetchEventsFeed event, Emit emit) async {
    try {
      emit(state.pending(value: state.getValueOrNull));
      final (events, pagination) = await _repository.getEvents(search: '', page: 1, size: 10);
      final newState = state.value.copyWith(events: events, pagination: pagination);
      emit(state.done(newState));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _searchEvents(SearchEvents event, Emit emit) async {
    try {
      final (events, pagination) = await _repository.getEvents(search: event.value, page: 1);
      final newState = state.value.copyWith(events: events, pagination: pagination);
      emit(state.done(newState));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _pagination(PaginationEvent event, Emit emit) async {
    try {
      if (state.value.pagination?.next == false) return;
      emit(state.pagination(value: state.getValueOrNull));
      final (events, pagination) = await _repository.getEvents(page: state.value.pagination!.page + 1);
      final newEvents = [...state.value.events, ...events];
      final newState = state.value.copyWith(events: newEvents, pagination: pagination);
      emit(state.done(newState));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
