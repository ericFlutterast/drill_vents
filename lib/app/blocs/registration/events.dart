abstract class RegistrationEvent {
  RegistrationEvent({this.publishToPipe = false});

  final bool publishToPipe;
}

final class CreateUserEvent extends RegistrationEvent {
  CreateUserEvent({required this.email, required this.password, super.publishToPipe});

  final String email, password;
}
