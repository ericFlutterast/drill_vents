import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/detail_event/events.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/cache_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<DetailEventModel>;
typedef Emit = Emitter<_State>;

final class DetailEventBloc extends Bloc<DetailEvents, _State> {
  DetailEventBloc(this._cache, this._repository, this._logger) : super(const CommonBlocState.init()) {
    on<FetchDetailEvent>(_fetchDetailEvent);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final FastCache _cache;

  Future<void> _fetchDetailEvent(FetchDetailEvent event, Emit emit) async {
    try {
      emit(state.pending());

      final cacheKey = CacheKey.event(event.id);
      DetailEventModel? item = _cache.get<DetailEventModel>(cacheKey);

      if (item == null) {
        item = await _repository.getEvent(event.id);
        _cache.set(cacheKey, item, duration: const Duration(seconds: 10));
      }

      emit(state.done(item));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
