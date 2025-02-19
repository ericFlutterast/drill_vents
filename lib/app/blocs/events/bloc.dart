import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/events/events.dart';
import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/common/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<Iterable<EventModel>>;
typedef Emit = Emitter<_State>;

final class EventsBloc extends Bloc<Events, _State> {
  EventsBloc({required IDataRepository repository}) : _repository = repository, super(CommonBlocState.init()) {
    on<Events>((event, emit) async {
      switch (event) {
        case FetchEvents():
          await _fetchEvents(event, emit);
        case SearchEvents():
      }
    });

    on<SearchEvents>(_searchEvents, transformer: bloc_concurrency.droppable());
  }

  final IDataRepository _repository;

  Future<void> _fetchEvents(FetchEvents event, Emit emit) async {
    try {
      emit(state.loading());
      final result = await _repository.fetchEvents();
      emit(state.done(result));
    } catch (error, stackTrace) {
      Logger().log.e(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _searchEvents(SearchEvents event, Emit emit) async {
    try {
      final result = await _repository.searchEvents(event.value);
      emit(state.done(result));
    } catch (error, stackTrace) {
      Logger().log.e(error, error: error, stackTrace: stackTrace);
    }
  }
}
