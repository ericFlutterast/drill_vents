import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Event
abstract class ProfileEvent {}

final class UpdateProfileInfoEvent extends ProfileEvent {
  UpdateProfileInfoEvent({this.name, this.email, this.phone, this.telegram, this.whatsapp, this.vk});

  final String? name, email, phone, telegram, whatsapp, vk;
}

final class UserEventsReceivingEvent extends ProfileEvent {}

///State

final class ProfileStateModel extends Equatable {
  const ProfileStateModel({this.events = const [], this.organization = const []});

  final Iterable<EventCardModel> events;
  final Iterable<OrgCardModel> organization;

  @override
  List<Object?> get props => [events, events];

  ProfileStateModel copyWith({Iterable<EventCardModel>? events, Iterable<OrgCardModel>? organization}) =>
      ProfileStateModel(events: events ?? this.events, organization: organization ?? this.organization);
}

typedef ProfileState = CommonBlocState<ProfileStateModel>;
typedef Emit = Emitter<ProfileState>;

///Bloc
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required Logger logger, required BackendAPI repository, required Pipe pipe})
    : _logger = logger,
      _repository = repository,
      _pipe = pipe,
      super(const ProfileState.init(value: ProfileStateModel())) {
    on<UpdateProfileInfoEvent>(_updateProfileInfo);
    on<UserEventsReceivingEvent>(_fetchUserEvents);
  }

  final Logger _logger;
  final BackendAPI _repository;
  final Pipe _pipe;

  Future<void> _updateProfileInfo(UpdateProfileInfoEvent event, Emit emit) async {
    try {
      await _repository.updateMyProfile(
        name: event.name,
        email: event.email,
        phone: event.phone,
        telegram: event.telegram,
        whatsapp: event.whatsapp,
        vk: event.vk,
      );
      _pipe.publish(UpdateUserDataPipeEvent());
    } on DioException catch (error, stackTrace) {
      _logger.error('DioException', error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }

  Future<void> _fetchUserEvents(UserEventsReceivingEvent event, Emit emit) async {
    try {
      emit(state.pending(value: state.getValueOrNull ?? const ProfileStateModel()));
      final result = await Future.wait([_repository.getEvents(page: 1, size: 20), _repository.getMyOrgs()]);
      if (result case [(Iterable<EventCardModel> events, PaginationModel _), Iterable<OrgCardModel> organizations]) {
        //TODO: должен появиться эндпоит для получения ивентов только для конкретного узера вместо where
        final userEvents = events.where((element) => element.booking != null);
        final newStateValue = state.value.copyWith(events: userEvents, organization: organizations);
        emit(state.done(newStateValue));
      } else {
        throw Exception('Не удалось получить данные');
      }
    } on DioException catch (error, stackTrace) {
      _logger.error('DioException', error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }
}
