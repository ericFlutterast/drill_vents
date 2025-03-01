import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailSpotListSectionState = CommonBlocState<List<EventCardModel>>;
typedef _Emit = Emitter<DetailSpotListSectionState>;

abstract class DetailSpotListSectionEvent {}

class FetchDetailSpotEvents extends DetailSpotListSectionEvent {
  FetchDetailSpotEvents(this.spotID);

  final String spotID;
}

class DetailSpotListSectionBloc extends Bloc<DetailSpotListSectionEvent, DetailSpotListSectionState> {
  DetailSpotListSectionBloc(this.api, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailSpotEvents>(_fetchEvents);
  }

  final BackendAPI api;
  final Logger logger;

  Future<void> _fetchEvents(FetchDetailSpotEvents event, _Emit emit) async {
    try {
      emit(state.pending());

      final events = await api.getSpotEvents(event.spotID);

      emit(state.done(events));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
