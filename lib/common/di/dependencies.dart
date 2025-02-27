import 'package:drill_events/app/blocs/auth/bloc.dart';
import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/registration/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
final class Dependencies {
  late final Logger logger;
  late final FastCache fastCache;
  late final Pipe pipe;

  //Network
  late final HttpApiClient httpApiClient;

  //Data
  late final DataRepository repository;
  late final SharedPreferences sharedPreferences;
  late final FlutterSecureStorage secureStorage;

  //Blocs
  late final AuthBloc authBloc;
  late final EventsBloc eventsBloc;
  late final SignUpToEventBloc signUpToEventBloc;
  late final DetailEventBloc detailEventBloc;
  late final RegistrationBloc registrationBloc;
}
