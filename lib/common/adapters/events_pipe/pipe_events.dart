abstract class PipeEvent {}

final class UserIsCreated extends PipeEvent {
  UserIsCreated(this.uid);

  final String uid;
}

final class UserIsReceived extends PipeEvent {
  UserIsReceived(this.email);

  final String email;
}
