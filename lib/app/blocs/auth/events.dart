import 'package:drill_events/app/blocs/common_bloc_event.dart';

abstract class AuthEvents implements CommonBlocEvent {
  AuthEvents({this.publishToPipe = false});

  @override
  final bool publishToPipe;
}

final class GetJwtTokenEvent extends AuthEvents {}

final class GetUserInfo extends AuthEvents {
  GetUserInfo({required this.uid, super.publishToPipe});

  final String uid;
}
