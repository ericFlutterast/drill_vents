import 'package:drill_events/app/blocs/common_bloc_event.dart';

abstract class SignUpToEvent implements CommonBlocEvent {
  const SignUpToEvent({this.publishToPipe = false});

  @override
  final bool publishToPipe;
}

final class SignUpEvent extends SignUpToEvent {
  const SignUpEvent({required this.email});

  final String email;
}
