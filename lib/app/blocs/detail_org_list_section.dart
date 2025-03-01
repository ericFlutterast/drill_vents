import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/new_models/states.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailOrgListSectionState = CommonBlocState<DetailOrgListSection>;
typedef _Emit = Emitter<DetailOrgListSectionState>;

abstract class DetailOrgListSectionEvent {}

// TODO: rename
class FetchDetailOrgLists extends DetailOrgListSectionEvent {
  FetchDetailOrgLists(this.orgID);

  final String orgID;
}

class DetailOrgListSectionBloc extends Bloc<DetailOrgListSectionEvent, DetailOrgListSectionState> {
  DetailOrgListSectionBloc(this.api, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailOrgLists>(_fetchLists);
  }

  final BackendAPI api;
  final Logger logger;

  Future<void> _fetchLists(FetchDetailOrgLists event, _Emit emit) async {
    try {
      emit(state.pending());

      final results = await Future.wait([api.getOrgEvents(event.orgID), api.getOrgSpots(event.orgID)]);

      final events = results[0] as List<EventCardModel>;
      final spots = results[1] as List<SpotCardModel>;

      final newState = DetailOrgListSection(events: events, spots: spots);

      emit(state.done(newState));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
