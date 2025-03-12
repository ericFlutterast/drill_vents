import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:drill_events/common/utils/cache_keys.dart';
import 'package:drill_events/common/utils/functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DetailEvents {}

final class FetchDetailEvent extends DetailEvents {
  FetchDetailEvent({required this.id});

  final String id;
}

final class SetBookingInfoEvent extends DetailEvents {
  SetBookingInfoEvent(this.booking);
  final BookingModel booking;
}

typedef DetailEventState = CommonBlocState<DetailEventModel>;
typedef Emit = Emitter<DetailEventState>;

final class DetailEventBloc extends Bloc<DetailEvents, DetailEventState> {
  DetailEventBloc({
    required FastCache cache,
    required BackendAPI repository,
    required Logger logger,
    required Pipe pipe,
  }) : _logger = logger,
       _repository = repository,
       _cache = cache,
       _pipe = pipe,
       super(const CommonBlocState.init()) {
    on<FetchDetailEvent>(_fetchDetailEvent);
    on<SetBookingInfoEvent>(_setBookingInfo);

    _pipe.listen((event) {
      if (event case BookPipeEvent event) {
        add(SetBookingInfoEvent(event.booking));
      }
    });
  }

  final Logger _logger;
  final BackendAPI _repository;
  final FastCache _cache;
  final Pipe _pipe;

  Future<void> _fetchDetailEvent(FetchDetailEvent event, Emit emit) async {
    try {
      emit(state.pending());

      final cacheKey = CacheKey.event(event.id);
      DetailEventModel? item = _cache.get<DetailEventModel>(cacheKey);

      if (item == null) {
        item = await _repository.getEvent(event.id);
        final cities = await _repository.getCities();
        final necessaryCity = findCity(cities.toList(), item.spot.cityId);
        item = item.copyWith(spotCity: necessaryCity?.title);
        _cache.set(cacheKey, item, duration: const Duration(seconds: 10));
      }

      emit(state.done(item));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _setBookingInfo(SetBookingInfoEvent event, Emit emit) async {
    try {
      DetailEventModel detailEvent = state.value;
      final booking = ShortBookingModel(reason: event.booking.reason, approved: event.booking.approved);
      detailEvent = detailEvent.copyWith(booking: booking);
      emit(state.copyWith(value: detailEvent));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
