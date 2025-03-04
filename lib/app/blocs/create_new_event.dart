import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Event
final class CreateNewEvent {
  CreateNewEvent(this.newEvent);

  final NewEventModel newEvent;
}

typedef CreateNewEventState = CommonBlocState<DetailEventModel>;
typedef Emit = Emitter<CreateNewEventState>;

///Bloc
final class CreateNewEventBloc extends Bloc<CreateNewEvent, CreateNewEventState> {
  CreateNewEventBloc(this._repository, this._logger) : super(const CreateNewEventState.init()) {
    on<CreateNewEvent>(_createNewEvent);
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _createNewEvent(CreateNewEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.createEvent(event.newEvent);
      emit(state.done(result));
    } on DioException catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } finally {
      emit(state.idle());
    }
  }
}
