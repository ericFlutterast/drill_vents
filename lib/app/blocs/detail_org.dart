import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/file_firebase_storage.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

typedef DetailOrgState = CommonBlocState<DetailOrgStateModel>;
typedef _Emit = Emitter<DetailOrgState>;

///Events
abstract class DetailOrgEvent {}

final class FetchDetailOrg extends DetailOrgEvent {
  FetchDetailOrg(this.orgID);

  final String orgID;
}

final class SelectOrgAvatar extends DetailOrgEvent {
  SelectOrgAvatar(this.orgId);

  final String orgId;
}

///State

final class DetailOrgStateModel extends Equatable {
  const DetailOrgStateModel({required this.orgModel, this.orgAvatar});

  final String? orgAvatar;
  final DetailOrgModel orgModel;

  @override
  List<Object?> get props => [orgAvatar, orgModel];

  DetailOrgStateModel copyWith({String? orgAvatar, DetailOrgModel? orgModel}) =>
      DetailOrgStateModel(orgAvatar: orgAvatar ?? this.orgAvatar, orgModel: orgModel ?? this.orgModel);
}

class DetailOrgBloc extends Bloc<DetailOrgEvent, DetailOrgState> {
  DetailOrgBloc({
    required BackendAPI api,
    required Logger logger,
    required FileStorage fileStorage,
    required ImagePicker imagePicker,
  }) : _api = api,
       _logger = logger,
       _fileStorage = fileStorage,
       _imagePicker = imagePicker,
       super(const CommonBlocState.init()) {
    on<FetchDetailOrg>(_fetchOrg);
    on<SelectOrgAvatar>(_selectOrgAvatar);
  }

  final BackendAPI _api;
  final Logger _logger;
  final FileStorage _fileStorage;
  final ImagePicker _imagePicker;

  Future<void> _fetchOrg(FetchDetailOrg event, _Emit emit) async {
    try {
      emit(state.pending());

      final org = await _api.getOrg(event.orgID);
      final avatar = await _fileStorage.getFileDownloadUrl('${StorageDirectory.orgAvatars}/${event.orgID}');

      emit(state.done(DetailOrgStateModel(orgModel: org, orgAvatar: avatar)));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _selectOrgAvatar(SelectOrgAvatar event, _Emit emit) async {
    try {
      final imageFile = await _imagePicker.pickMedia();
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _fileStorage.putFile(
          file: File(imageFile.path),
          path: '${StorageDirectory.orgAvatars}/${event.orgId}',
        );
      }
      emit(state.done(state.value.copyWith(orgAvatar: imageUrl)));
    } on PlatformException catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error('Не удалось получить доступ к фото', value: state.value));
    }
  }
}
