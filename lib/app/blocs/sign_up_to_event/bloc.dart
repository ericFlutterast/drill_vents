import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/shared_preferences/shared_preferences_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _State = CommonBlocState<String>;
typedef Emit = Emitter<_State>;

final class SignUpToEventBloc extends Bloc<SignUpToEvent, _State> {
  SignUpToEventBloc({
    required DataRepository repository,
    required SharedPreferences sharedPreferences,
    required Logger logger,
  }) : _repository = repository,
       _sharedPreferences = sharedPreferences,
       _logger = logger,
       super(const CommonBlocState.init()) {
    on<SignUpEvent>(_fetchDetailEvent);
  }

  final DataRepository _repository;
  final SharedPreferences _sharedPreferences;
  final Logger _logger;

  Future<void> _fetchDetailEvent(SignUpEvent event, Emit emit) async {
    try {
      emit(state.pending());

      if (!_sharedPreferences.containsKey(SharedPrefKeys.email) ||
          _sharedPreferences.get(SharedPrefKeys.email) == null) {
        _sharedPreferences.setString(SharedPrefKeys.email, event.email);
      }

      await _repository.signUpToEvent(event.email);
      emit(state.done(null));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
