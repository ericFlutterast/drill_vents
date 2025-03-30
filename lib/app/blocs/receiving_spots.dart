import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/file_firebase_storage.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class ReceivingSpotsEvent {}

final class GetSpotsEvent extends ReceivingSpotsEvent {
  GetSpotsEvent(this.orgId);

  final String orgId;
}

typedef ReceivingSpotsState = CommonBlocState<Iterable<SpotCardModel>>;
typedef _Emit = Emitter<ReceivingSpotsState>;

///Bloc
final class ReceivingSpotsBloc extends Bloc<ReceivingSpotsEvent, ReceivingSpotsState> {
  ReceivingSpotsBloc({required BackendAPI api, required Logger logger, required FileStorage fileStorage})
    : _api = api,
      _logger = logger,
      _fileStorage = fileStorage,
      super(const CommonBlocState.init()) {
    on<GetSpotsEvent>(_getSpots);
  }

  final BackendAPI _api;
  final Logger _logger;
  final FileStorage _fileStorage;

  Future<void> _getSpots(GetSpotsEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      final result = await _api.getOrgSpots(event.orgId);
      //TODO: Врнеменное решение
      final orgImage = await _fileStorage.getFileDownloadUrl('${StorageDirectory.orgAvatars}/${event.orgId}');

      emit(state.done(result.map((e) => e.copyWith(org: e.org.copyWith(imageUrl: orgImage)))));
    } on DioException catch (error, stackTrace) {
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
      emit(state.error(error.appErrorMessage));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    }
  }
}
