import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/registration/events.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Uid = String;
typedef _State = CommonBlocState<Uid>;
typedef _Emit = Emitter<_State>;

final class RegistrationBloc extends Bloc<RegistrationEvent, _State> {
  RegistrationBloc({required DataRepository repository, required Logger logger, required Pipe pipe})
    : _logger = logger,
      _repository = repository,
      _pipe = pipe,
      super(const CommonBlocState.init()) {
    on<CreateUserEvent>(_createUser);
  }

  final DataRepository _repository;
  final Logger _logger;
  final Pipe _pipe;

  Future<void> _createUser(CreateUserEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      final userId = await _repository.createUser(email: event.email, password: event.password);
      emit(state.done(userId));

      // event.publishToPipe - не должно существовать. Эта штука позволяет управлять логикой блока извне. Пайп должен
      // быть скрыт от глаз и тот кто общается с блоком даже намеков не должен получать о том что тут есть пайп. Это
      // все равно что неявно связать 2 класса через посредника
      //
      // Если нужна такая штука, то лучше назвать как-нибудь иначе, сосмыслом.
      // Хз там event.createAdmin
      // if (event.createAdmin)  _pipe.publish(ПригласитьМатьНаТанец(admin));
      if (event.publishToPipe) {
        _pipe.publish(UserIsCreated(userId));
      }
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
