import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/network/api_client.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
final class Dependencies {
  late final DrillLogger logger;
  late final FastCache fastCache;

  //Network
  late final HttpApiClient httpApiClient;

  //Data
  late final DataRepository repository;
  late final SharedPreferences sharedPreferences;

  //Blocs
  late final EventsBloc eventsBloc;
  late final SignUpToEventBloc signUpToEventBloc;
  late final DetailEventBloc detailEventBloc;
}
