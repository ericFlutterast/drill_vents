import 'package:drill_events/app/blocs/auth/events.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/models/user.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/secure_storage/secure_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef _State = CommonBlocState<UserModel>;
typedef Emit = Emitter<_State>;

final class AuthBloc extends Bloc<AuthEvents, _State> {
  AuthBloc(this._repository, this._secureStorage, this._logger) : super(const CommonBlocState.init()) {
    on<GetJwtTokenEvent>(_getJwtToken);
  }

  final Logger _logger;
  final DataRepository _repository;
  final FlutterSecureStorage _secureStorage;

  Future<void> _getJwtToken(GetJwtTokenEvent event, Emit emit) async {
    try {
      emit(state.pending());
      String? currentToken = await _secureStorage.read(key: SecureStorageKeys.jwt);
      if (currentToken == null) {
        currentToken = await _repository.getJwtToken();
        await _secureStorage.write(key: SecureStorageKeys.jwt, value: currentToken);
      }

      final user = await _getUser(currentToken);
      emit(state.done(user));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<UserModel> _getUser(String token) async {
    return _repository.fetchUserInfo(token);
  }
}
