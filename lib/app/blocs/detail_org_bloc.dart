import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/app/models/org.dart';
import 'package:drill_events/app/models/spot.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailOrgBlocState = CommonBlocState<OrgModel>;
typedef _Emit = Emitter<DetailOrgBlocState>;

abstract class DetailOrgEvent {}

class FetchDetailOrgEvent extends DetailOrgEvent {
  FetchDetailOrgEvent(this.orgID);

  final String orgID;
}

class DetailOrgBloc extends Bloc<DetailOrgEvent, DetailOrgBlocState> {
  DetailOrgBloc(this.repository, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailOrgEvent>(_fetchOrg);
  }

  final DataRepository repository;
  final Logger logger;

  Future<void> _fetchOrg(FetchDetailOrgEvent event, _Emit emit) async {
    try {
      emit(state.pending());

      final results = await Future.wait([
        repository.getOrg(event.orgID),
        repository.getOrgEvents(event.orgID),
        repository.getOrgSpots(event.orgID),
      ]);

      OrgModel org = results[0] as OrgModel;
      final events = results[1] as List<EventModel>;
      final spots = results[2] as List<SpotModel>;

      org = org.copyWith(events: events, spots: spots);

      emit(state.done(org));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
