import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/secure_storage/secure_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthEvents {
  AuthEvents();
}

final class CreateSessionEvent extends AuthEvents {
  CreateSessionEvent({required this.password, required this.email});

  final String email, password;
}

final class GetUserInfo extends AuthEvents {
  GetUserInfo({required this.uid, this.bookEvent = false});

  final bool bookEvent;
  final String uid;
}

typedef AuthState = CommonBlocState<UserModel>;
typedef Emit = Emitter<AuthState>;

final class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc({required BackendAPI repository, required FlutterSecureStorage secureStorage, required Logger logger})
    : _repository = repository,
      _secureStorage = secureStorage,
      _logger = logger,
      super(const CommonBlocState.init()) {
    on<CreateSessionEvent>(_createSession);
    on<GetUserInfo>(_getUser);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final FlutterSecureStorage _secureStorage;

  Future<void> _createSession(CreateSessionEvent event, Emit emit) async {
    try {
      emit(state.pending());
      String? accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
      if (accessToken == null) {
        final session = await _repository.createSession(event.email, event.password);
        accessToken = session.tokens.accessToken;
        await Future.wait([
          _secureStorage.write(key: SecureStorageKeys.accessToken, value: accessToken),
          _secureStorage.write(key: SecureStorageKeys.refreshToken, value: session.tokens.refreshToken),
        ]);
      }

      if (accessToken case String token) {
        add(GetUserInfo(uid: token));
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
      final user = await _repository.getMyProfile();
      emit(state.done(user));
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
