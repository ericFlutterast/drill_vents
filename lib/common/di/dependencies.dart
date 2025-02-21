import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/common/network/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
final class Dependencies {
  //Network
  late final HttpApiClient httpApiClient;

  //Data
  late final IDataRepository repository;
  late final SharedPreferences sharedPreferences;

  //Blocs
  late final EventsBloc eventsBloc;
  late final SignUpToEventBloc signUpToEventBloc;
  late final DetailEventBloc detailEventBloc;
}
