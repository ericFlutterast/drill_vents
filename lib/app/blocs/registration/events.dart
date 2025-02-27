import 'package:drill_events/app/blocs/common_bloc_event.dart';

abstract class RegistrationEvent implements CommonBlocEvent {
  RegistrationEvent({this.publishToPipe = false});

  @override
  final bool publishToPipe;
}

final class CreateUserEvent extends RegistrationEvent {
  CreateUserEvent({required this.email, required this.password, super.publishToPipe});

  final String email, password;
}
