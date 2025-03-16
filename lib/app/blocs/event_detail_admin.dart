import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/cache_keys.dart';
import 'package:drill_events/common/utils/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class EventDetailAdminEvent {}

final class FetchDetailEventAdmin extends EventDetailAdminEvent {
  FetchDetailEventAdmin(this.eventId);
  final String eventId;
}

///State
typedef EventDetailAdminState = CommonBlocState<EventDetailAdminStateModel>;

final class EventDetailAdminStateModel extends Equatable {
  const EventDetailAdminStateModel({required this.event, this.participants = const []});

  final Iterable<ShortUserModel> participants;
  final DetailEventModel event;

  @override
  List<Object?> get props => [participants, event];

  EventDetailAdminStateModel copyWith({Iterable<ShortUserModel>? participants, DetailEventModel? event}) =>
      EventDetailAdminStateModel(event: event ?? this.event, participants: participants ?? this.participants);
}

typedef _Emit = Emitter<EventDetailAdminState>;

final class EventDetailAdminBloc extends Bloc<EventDetailAdminEvent, EventDetailAdminState> {
  EventDetailAdminBloc({required Logger logger, required BackendAPI repository, required FastCache cache})
    : _logger = logger,
      _repository = repository,
      _cache = cache,

      super(const CommonBlocState.init()) {
    on<FetchDetailEventAdmin>(_fetchDetailEvent);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final FastCache _cache;

  Future<void> _fetchDetailEvent(FetchDetailEventAdmin event, _Emit emit) async {
    try {
      emit(state.pending());

      final cacheKey = CacheKey.event(event.eventId);
      DetailEventModel? item = _cache.get<DetailEventModel>(cacheKey);

      final participants = await _repository.getParticipants(event.eventId);

      if (item == null) {
        final result = await Future.wait([_repository.getEvent(event.eventId), _repository.getCities()]);

        item = result[0] as DetailEventModel;
        final cities = result[1] as List<CityModel>;

        final necessaryCity = findCity(cities.toList(), item.spot.cityId);
        item = item.copyWith(spotCity: necessaryCity?.title);
        _cache.set(cacheKey, item, duration: const Duration(seconds: 10));
      }

      final newState =
          state.getValueOrNull?.copyWith(event: item, participants: participants) ??
          EventDetailAdminStateModel(event: item, participants: participants);

      emit(state.done(newState));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
