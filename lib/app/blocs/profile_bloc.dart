import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Event
abstract class ProfileEvent {}

final class UpdateProfileInfoEvent extends ProfileEvent {
  UpdateProfileInfoEvent({this.name, this.email, this.phone, this.telegram, this.whatsapp, this.vk});

  final String? name, email, phone, telegram, whatsapp, vk;
}

typedef ProfileState = CommonBlocState;
typedef Emit = Emitter<ProfileState>;

///Bloc
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required Logger logger, required BackendAPI repository, required Pipe pipe})
    : _logger = logger,
      _repository = repository,
      _pipe = pipe,
      super(const ProfileState.init()) {
    on<UpdateProfileInfoEvent>(_updateProfileInfo);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final Pipe _pipe;

  Future<void> _updateProfileInfo(UpdateProfileInfoEvent event, Emit emit) async {
    try {
      emit(state.pending());
      await _repository.updateMyProfile(
        name: event.name,
        email: event.email,
        phone: event.phone,
        telegram: event.telegram,
        whatsapp: event.whatsapp,
        vk: event.vk,
      );
      _pipe.publish(UpdateUserDataPipeEvent());
      emit(state.done(null));
    } on DioException catch (error, stackTrace) {
      _logger.error('DioException', error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }
}
