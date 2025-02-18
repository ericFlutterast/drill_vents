import 'package:drill_events/app/data/data_repository.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/common/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
sealed class _Event {}

final class FetchEvents extends _Event {}

///State
final class EventsState extends Equatable {
  const EventsState({this.events = const []});

  final Iterable<EventModel> events;

  @override
  List<Object?> get props => [events];

  EventsState copyWith({Iterable<EventModel>? events}) => EventsState(events: events ?? this.events);
}

typedef Emit = Emitter<EventsState>;

//Bloc
final class EventsBloc extends Bloc<_Event, EventsState> {
  EventsBloc() : super(const EventsState()) {
    on<_Event>((event, emit) async {
      switch (event) {
        case FetchEvents _:
          await _fetchEvents(event, emit);
      }
    });
  }

  final DataRepositoryImpl _repositoryImpl = DataRepositoryImpl();

  Future<dynamic> _fetchEvents(FetchEvents event, Emit emit) async {
    try {
      final result = await _repositoryImpl.fetchEvents();
      emit(state.copyWith(events: result));
    } catch (error, stackTrace) {
      Logger().log.e(error, error: error, stackTrace: stackTrace);
    }
  }
}
