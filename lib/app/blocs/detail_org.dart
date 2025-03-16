import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailOrgState = CommonBlocState<DetailOrgModel>;
typedef _Emit = Emitter<DetailOrgState>;

abstract class DetailOrgEvent {}

class FetchDetailOrg extends DetailOrgEvent {
  FetchDetailOrg(this.orgID);

  final String orgID;
}

class DetailOrgBloc extends Bloc<DetailOrgEvent, DetailOrgState> {
  DetailOrgBloc(this.api, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailOrg>(_fetchOrg);
  }

  final BackendAPI api;
  final Logger logger;

  Future<void> _fetchOrg(FetchDetailOrg event, _Emit emit) async {
    try {
      emit(state.pending());

      final org = await api.getOrg(event.orgID);

      emit(state.done(org));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
