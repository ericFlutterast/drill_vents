import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/auth/events.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/models/user.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:drill_events/common/secure_storage/secure_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _State = CommonBlocState<UserModel>;
typedef Emit = Emitter<_State>;

final class AuthBloc extends Bloc<AuthEvents, _State> {
  AuthBloc(this._repository, this._secureStorage, this._logger, this._pipe) : super(const CommonBlocState.init()) {
    on<GetJwtTokenEvent>(_getJwtToken);
    on<GetUserInfo>(_getUser);

    _pipe.listen((pipeEvent) {
      if (pipeEvent is UserIsCreated) {
        add(GetUserInfo(uid: pipeEvent.uid, publishToPipe: true));
      }
    });
  }

  final Pipe _pipe;
  final Logger _logger;
  final DataRepository _repository;
  final FlutterSecureStorage _secureStorage;

  Future<void> _getJwtToken(GetJwtTokenEvent event, Emit emit) async {
    try {
      emit(state.pending());
      String? currentToken = await _secureStorage.read(key: SecureStorageKeys.jwt);
      if (true) {
        currentToken = await _repository.getJwtToken();
        await _secureStorage.write(key: SecureStorageKeys.jwt, value: currentToken);
      }

      //TODO: убрать когда будет готова авторизация
      final shared = await SharedPreferences.getInstance();
      if (shared.containsKey('uid')) {
        final uid = shared.getString('uid')!;
        add(GetUserInfo(uid: uid));
      }

      if (currentToken case String token) {
        //TODO: в токене будет звшиврован id
        //add(GetUserInfo(uid: '972d4ea4-93f2-48ec-b121-9306d56e4aca'));
      }
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _getUser(GetUserInfo event, Emit emit) async {
    try {
      emit(state.pending());
      final user = await _repository.fetchUserInfo(event.uid);
      emit(state.done(user));
      if (event.publishToPipe) {
        _pipe.publish(UserIsReceived(user.email));
      }
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } finally {
      emit(state.idle(value: state.value));
    }
  }
}
