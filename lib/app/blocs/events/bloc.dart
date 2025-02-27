import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/events/events.dart';
import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<Iterable<EventModel>>;
typedef Emit = Emitter<_State>;

final class EventsBloc extends Bloc<Events, _State> {
  EventsBloc(this._repository, this._logger) : super(const CommonBlocState.init()) {
    on<FetchEventsFeed>(_fetchFeed);
    on<SearchEvents>(_searchEvents, transformer: bloc_concurrency.droppable());
  }

  final DataRepository _repository;
  final Logger _logger;

  Future<void> _fetchFeed(FetchEventsFeed event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.searchEvents("");
      emit(state.done(result));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _searchEvents(SearchEvents event, Emit emit) async {
    try {
      final result = await _repository.searchEvents(event.value);
      emit(state.done(result));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
