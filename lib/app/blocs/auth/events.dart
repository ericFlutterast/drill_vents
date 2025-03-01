abstract class AuthEvents {
  AuthEvents({this.publishToPipe = false});

  final bool publishToPipe;
}

final class GetJwtTokenEvent extends AuthEvents {}

final class GetUserInfo extends AuthEvents {
  GetUserInfo({required this.uid, super.publishToPipe});

  final String uid;
}
