import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/app/models/spot.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailSpotBlocState = CommonBlocState<SpotModel>;
typedef _Emit = Emitter<DetailSpotBlocState>;

abstract class DetailSpotEvent {}

class FetchDetailSpotEvent extends DetailSpotEvent {
  FetchDetailSpotEvent(this.spotID);

  final String spotID;
}

// Может попробуем так писать? В одном файле, так как ивенты никогда много места не занимают. Заодно уменьшим
// вложенность и бойлерплейт
class DetailSpotBloc extends Bloc<DetailSpotEvent, DetailSpotBlocState> {
  DetailSpotBloc(this.repository, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailSpotEvent>(_fetchSpot);
  }

  final DataRepository repository;
  final Logger logger;

  Future<void> _fetchSpot(FetchDetailSpotEvent event, _Emit emit) async {
    try {
      emit(state.pending());

      final results = await Future.wait([repository.getSpot(event.spotID), repository.getSpotEvents(event.spotID)]);

      SpotModel spot = results[0] as SpotModel;
      final events = results[1] as List<EventModel>;

      spot = spot.copyWith(events: events);

      emit(state.done(spot));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
