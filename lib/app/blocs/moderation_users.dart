import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Events
abstract class ModerationUsersEvent {
  ModerationUsersEvent(this.eventId);
  final String eventId;
}

final class FetchUserForModerationEvent extends ModerationUsersEvent {
  FetchUserForModerationEvent(super.eventId);
}

final class ApproveUserEvent extends ModerationUsersEvent {
  ApproveUserEvent(super.eventId, {required this.userId});
  final String userId;
}

final class DeclineUserEvent extends ModerationUsersEvent {
  DeclineUserEvent(super.eventId, {required this.userId});
  final String userId;
}

//State

typedef ModerationUsersState = CommonBlocState<List<ShortUserModel>>;
typedef Emit = Emitter<ModerationUsersState>;

final class ModerationUsersBloc extends Bloc<ModerationUsersEvent, ModerationUsersState> {
  ModerationUsersBloc({required Logger logger, required BackendAPI api})
    : _logger = logger,
      _api = api,
      super(const CommonBlocState.init()) {
    on<FetchUserForModerationEvent>(_fetchUser);
    on<ApproveUserEvent>(_approveUser);
    on<DeclineUserEvent>(_declineUser);
  }

  final Logger _logger;
  final BackendAPI _api;

  Future<void> _fetchUser(FetchUserForModerationEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _api.getUserForModeration(event.eventId);
      emit(state.done(result.toList()));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _approveUser(ApproveUserEvent event, Emit emit) async {
    try {
      await _api.approveBooking(event.eventId, event.userId);

      final users = [...state.value];
      final approvedUser = _findUserFor(event.userId);
      users.remove(approvedUser);

      emit(state.done(users));
    } on DioException catch (error, stackTrace) {
      emit(state.error(value: state.getValueOrNull, error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(value: state.getValueOrNull, error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } finally {
      emit(state.done(state.getValueOrNull));
    }
  }

  Future<void> _declineUser(DeclineUserEvent event, Emit emit) async {
    try {
      await _api.rejectBooking(event.eventId, event.userId, 'reject');

      final users = [...state.value];
      final approvedUser = _findUserFor(event.userId);
      users.remove(approvedUser);

      emit(state.done(users));
    } on DioException catch (error, stackTrace) {
      emit(state.error(value: state.getValueOrNull, error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(value: state.getValueOrNull, error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } finally {
      emit(state.done(state.getValueOrNull));
    }
  }

  ShortUserModel? _findUserFor(String id) {
    if (state.hasValue) {
      for (final user in state.value) {
        if (user.id == id) return user;
      }
    }

    return null;
  }
}
