import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/secure_storage/secure_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///Events
abstract class AuthEvents {
  AuthEvents();
}

final class CreateSessionEvent extends AuthEvents {
  CreateSessionEvent({required this.password, required this.email});

  final String email, password;
}

final class GetUserInfo extends AuthEvents {
  GetUserInfo();
}

final class CreateAuthBook extends AuthEvents {
  CreateAuthBook({required this.password, required this.email, required this.eventId});

  final String email, password, eventId;
}

final class Logout extends AuthEvents {}

///Bloc
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
    on<CreateAuthBook>(_createAuthorizeAndBook);
    on<Logout>(_logout);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final FlutterSecureStorage _secureStorage;

  Future<void> _createAuthorizeAndBook(CreateAuthBook event, Emit emit) async {
    try {
      emit(state.pending());
      final (session, book) = await _repository.createAuthorizeAndBook(
        email: event.email,
        password: event.password,
        eventId: event.eventId,
      );

      await _saveTokens(session.tokens);

      add(GetUserInfo());
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _createSession(CreateSessionEvent event, Emit emit) async {
    try {
      emit(state.pending());
      String? accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
      if (accessToken == null) {
        final session = await _repository.createSession(event.email, event.password);
        accessToken = session.tokens.accessToken;
        await _saveTokens(session.tokens);
      }

      add(GetUserInfo());
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

      if (error.response?.data case <String, dynamic>{'status': final int code, 'message': final String message}) {
        if (code == 403 && message == 'token is expired') {
          await _refresh();
        }
      }
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } finally {
      emit(state.idle(value: state.value));
    }
  }

  Future<void> _logout(Logout event, Emit emit) async {
    try {
      emit(state.pending());
      await _clearTokens();
      emit(state.idle(value: null));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.response?.data['message'] ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: SecureStorageKeys.accessToken),
      _secureStorage.delete(key: SecureStorageKeys.refreshToken),
    ]);
  }

  Future<void> _refresh() async {
    try {
      final session = await _repository.refreshSession();
      await _saveTokens(session.tokens);
      add(GetUserInfo());
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _saveTokens(TokensModel tokens) async {
    await Future.wait([
      _secureStorage.write(key: SecureStorageKeys.accessToken, value: tokens.accessToken),
      _secureStorage.write(key: SecureStorageKeys.refreshToken, value: tokens.refreshToken),
    ]);
  }
}
