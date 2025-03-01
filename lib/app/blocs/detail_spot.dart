import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailSpotState = CommonBlocState<DetailSpotModel>;
typedef _Emit = Emitter<DetailSpotState>;

abstract class DetailSpotEvent {}

class FetchDetailSpot extends DetailSpotEvent {
  FetchDetailSpot(this.spotID);

  final String spotID;
}

class DetailSpotBloc extends Bloc<DetailSpotEvent, DetailSpotState> {
  DetailSpotBloc(this.api, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailSpot>(_fetchSpot);
  }

  final BackendAPI api;
  final Logger logger;

  Future<void> _fetchSpot(FetchDetailSpot event, _Emit emit) async {
    try {
      emit(state.pending());

      api.getSpotEvents(event.spotID);

      final spot = await api.getSpot(event.spotID);

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
