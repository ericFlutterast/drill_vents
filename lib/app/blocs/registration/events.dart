abstract class RegistrationEvent {}

final class CreateUserEvent extends RegistrationEvent {
  CreateUserEvent({required this.email, required this.password});

  final String email, password;
}
