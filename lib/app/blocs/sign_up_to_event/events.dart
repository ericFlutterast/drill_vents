abstract class SignUpToEvent {
  const SignUpToEvent();
}

final class SignUpEvent extends SignUpToEvent {
  const SignUpEvent({required this.email});

  final String email;
}
