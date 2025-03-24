import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/new_models/states.dart';
import 'package:drill_events/common/adapters/file_firebase_storage.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:drill_events/common/utils/functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DetailOrgListSectionState = CommonBlocState<DetailOrgListSection>;
typedef _Emit = Emitter<DetailOrgListSectionState>;

abstract class DetailOrgListSectionEvent {}

// TODO: rename
class FetchDetailOrgLists extends DetailOrgListSectionEvent {
  FetchDetailOrgLists(this.orgID);

  final String orgID;
}

class DetailOrgListSectionBloc extends Bloc<DetailOrgListSectionEvent, DetailOrgListSectionState> {
  DetailOrgListSectionBloc({required BackendAPI api, required Logger logger, required FileStorage fileStorage})
    : _fileStorage = fileStorage,
      _logger = logger,
      _api = api,
      super(const CommonBlocState.init()) {
    on<FetchDetailOrgLists>(_fetchLists);
  }

  final BackendAPI _api;
  final Logger _logger;
  final FileStorage _fileStorage;

  Future<void> _fetchLists(FetchDetailOrgLists event, _Emit emit) async {
    try {
      emit(state.pending());

      final results = await Future.wait([
        _api.getOrgEvents(event.orgID),
        _api.getOrgSpots(event.orgID),
        _api.getCities(),
      ]);

      final events = results[0] as List<EventCardModel>;
      final spots = results[1] as List<SpotCardModel>;
      final cities = results[2] as List<CityModel>;

      final eventOrgAvatars = await _fileStorage.getListFileDownloadUrl(
        events.map((event) => '${StorageDirectory.orgAvatars}/${event.org.id}'),
      );
      final spotOrgAvatars = await _fileStorage.getListFileDownloadUrl(
        spots.map((spot) => '${StorageDirectory.orgAvatars}/${spot.org.id}'),
      );

      final newState = DetailOrgListSection(
        events:
            events.mapIndexed((i, event) {
              return event.copyWith(org: event.org.copyWith(imageUrl: eventOrgAvatars.elementAt(i)));
            }).toList(),
        spots:
            _getSpotsWithCities(cities: cities, spots: spots).mapIndexed((i, spot) {
              return spot.copyWith(org: spot.org.copyWith(imageUrl: spotOrgAvatars.elementAt(i)));
            }).toList(),
      );

      emit(state.done(newState));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  List<SpotCardModel> _getSpotsWithCities({required List<CityModel> cities, required List<SpotCardModel> spots}) {
    for (final (i, spot) in spots.indexed) {
      final city = findCity(cities, spot.cityId);
      spots[i] = spot.copyWith(city: city?.title);
    }
    return spots;
  }
}
