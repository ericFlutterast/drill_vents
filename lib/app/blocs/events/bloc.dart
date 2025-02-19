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
        case FetchEvents _:
          await _fetchEvents(event, emit);
      }
    });
  }

  final IDataRepository _repository;

  Future<dynamic> _fetchEvents(FetchEvents event, Emit emit) async {
    try {
      emit(state.loading());
      final result = await _repository.fetchEvents();
      emit(state.done(result));
    } catch (error, stackTrace) {
      Logger().log.e(error, error: error, stackTrace: stackTrace);
    }
  }
}
