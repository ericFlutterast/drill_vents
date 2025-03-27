import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/adapters/file_firebase_storage.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

///Event
abstract class ProfileEvent {}

final class UpdateProfileInfoEvent extends ProfileEvent {
  UpdateProfileInfoEvent({this.name, this.email, this.phone, this.telegram, this.whatsapp, this.vk});

  final String? name, email, phone, telegram, whatsapp, vk;
}

final class UserEventsReceivingEvent extends ProfileEvent {}

final class SelectProfileAvatarEvent extends ProfileEvent {
  SelectProfileAvatarEvent(this.userId);

  final String userId;
}

///State

final class ProfileStateModel extends Equatable {
  const ProfileStateModel({this.events = const [], this.organization = const [], this.userAvatar});

  final String? userAvatar;
  final Iterable<EventCardModel> events;
  final Iterable<OrgCardModel> organization;

  @override
  List<Object?> get props => [events, events];

  ProfileStateModel copyWith({
    String? userAvatar,
    Iterable<EventCardModel>? events,
    Iterable<OrgCardModel>? organization,
  }) => ProfileStateModel(
    userAvatar: userAvatar ?? this.userAvatar,
    events: events ?? this.events,
    organization: organization ?? this.organization,
  );
}

typedef ProfileState = CommonBlocState<ProfileStateModel>;
typedef Emit = Emitter<ProfileState>;

///Bloc
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required Logger logger,
    required BackendAPI repository,
    required Pipe pipe,
    required ImagePicker imagePicker,
    required FileStorage fileStorage,
  }) : _fileStorage = fileStorage,
       _imagePicker = imagePicker,
       _logger = logger,
       _repository = repository,
       _pipe = pipe,
       super(const ProfileState.init(value: ProfileStateModel())) {
    on<UpdateProfileInfoEvent>(_updateProfileInfo);
    on<UserEventsReceivingEvent>(_fetchUserEvents);
    on<SelectProfileAvatarEvent>(_selectAvatar);
  }

  final FileStorage _fileStorage;
  final ImagePicker _imagePicker;
  final Logger _logger;
  final BackendAPI _repository;
  final Pipe _pipe;

  Future<void> _selectAvatar(SelectProfileAvatarEvent event, Emit emit) async {
    try {
      emit(state.pending(value: state.getValueOrNull));

      final pickedFile = await _imagePicker.pickMedia();

      File? avatar;
      String? imageUrl;
      if (pickedFile != null) {
        avatar = File(pickedFile.path);
        imageUrl = await _fileStorage.putFile(file: avatar, path: '${StorageDirectory.userAvatars}/${event.userId}');
      }

      final newState = state.value.copyWith(userAvatar: imageUrl);
      _pipe.publish(UpdateUserDataPipeEvent());
      emit(state.copyWith(value: newState));
    } on FirebaseException {
      emit(state.error('Не удалось загрузить фото', value: state.value));
    } on PlatformException catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error('Не удалось получить доступ к фото', value: state.value));
    } catch (error, stackTrace) {
      _logger.error('ProfileBloc', stackTrace: stackTrace);
      emit(state.error('Не удалось загрузить фото', value: state.value));
    } finally {
      emit(state.done(state.value));
    }
  }

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
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
      emit(state.error(error.appErrorMessage));
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

        final eventsAvatars = await _fileStorage.getListFileDownloadUrl(
          userEvents.map((event) => '${StorageDirectory.orgAvatars}/${event.org.id}'),
        );

        final orgAvatars = await _fileStorage.getListFileDownloadUrl(
          organizations.map((org) => '${StorageDirectory.orgAvatars}/${org.id}'),
        );

        final eventsWithImages =
            userEvents
                .mapIndexed((i, event) => event.copyWith(org: event.org.copyWith(imageUrl: eventsAvatars.elementAt(i))))
                .toList()
                .reversed;

        final orgsWithImages = organizations.mapIndexed((i, org) => org.copyWith(imageUrl: orgAvatars.elementAt(i)));

        final newStateValue = state.value.copyWith(events: eventsWithImages, organization: orgsWithImages);
        emit(state.done(newStateValue));
      } else {
        throw Exception('Не удалось получить данные');
      }
    } on DioException catch (error, stackTrace) {
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
      emit(state.error(error.appErrorMessage));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }
}
