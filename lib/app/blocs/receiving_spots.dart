import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class ReceivingSpotsEvent {}

final class GetSpotsEvent extends ReceivingSpotsEvent {}

typedef _State = CommonBlocState;
typedef _Emit = Emitter<_State>;

///Bloc
final class ReceivingSpotsBloc extends Bloc<ReceivingSpotsEvent, _State> {
  ReceivingSpotsBloc(this._repository, this._logger) : super(const CommonBlocState.init()) {
    on<GetSpotsEvent>(_getSpots);
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _getSpots(GetSpotsEvent event, _Emit emit) async {
    try {} on DioException catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }
}
