abstract class BookingEvent {
  const BookingEvent({this.publishToPipe = false});

  final bool publishToPipe;
}

final class BookToEvent extends BookingEvent {
  const BookToEvent({required this.email});

  final String email;
}
