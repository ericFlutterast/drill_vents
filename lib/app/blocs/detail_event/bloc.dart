import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/detail_event/events.dart';
import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/common/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<Object>;
typedef Emit = Emitter<_State>;

final class DetailEventBloc extends Bloc<DetailEvents, _State> {
  DetailEventBloc({required IDataRepository repository})
    : _repository = repository,
      super(const CommonBlocState.init()) {
    on<FetchDetailEvent>(_fetchDetailEvent);
  }

  final IDataRepository _repository;

  Future<void> _fetchDetailEvent(FetchDetailEvent event, Emit emit) async {
    try {
      final result = await _repository.getDetailEvent(event.id);
    } catch (error, stackTrace) {
      emit(state.error(error));
      Logger().log.e(error, error: error, stackTrace: stackTrace);
    }
  }
}
