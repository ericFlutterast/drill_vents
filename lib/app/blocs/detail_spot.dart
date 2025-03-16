import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class DetailSpotEvent {}

class FetchDetailSpot extends DetailSpotEvent {
  FetchDetailSpot(this.spotID);

  final String spotID;
}

///State
typedef DetailSpotState = CommonBlocState<DetailSpotStateModel>;

final class DetailSpotStateModel extends Equatable {
  const DetailSpotStateModel({required this.spot, this.events = const []});

  final DetailSpotModel spot;
  final Iterable<EventCardModel> events;

  @override
  List<Object?> get props => [spot, events];

  DetailSpotStateModel copyWith({DetailSpotModel? spot, Iterable<EventCardModel>? events}) =>
      DetailSpotStateModel(spot: spot ?? this.spot, events: events ?? this.events);
}

typedef _Emit = Emitter<DetailSpotState>;

class DetailSpotBloc extends Bloc<DetailSpotEvent, DetailSpotState> {
  DetailSpotBloc(this.api, this.logger) : super(const CommonBlocState.init()) {
    on<FetchDetailSpot>(_fetchSpot);
  }

  final BackendAPI api;
  final Logger logger;

  Future<void> _fetchSpot(FetchDetailSpot event, _Emit emit) async {
    try {
      emit(state.pending());

      final result = await Future.wait([api.getSpotEvents(event.spotID), api.getSpot(event.spotID)]);

      final spotEvents = result[0] as Iterable<EventCardModel>;
      final spot = result[1] as DetailSpotModel;

      final newValue =
          state.getValueOrNull?.copyWith(spot: spot, events: spotEvents) ??
          DetailSpotStateModel(spot: spot, events: spotEvents);
      emit(state.done(newValue));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
