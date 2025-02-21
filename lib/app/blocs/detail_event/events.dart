abstract class DetailEvents {
  const DetailEvents();
}

final class FetchDetailEvent extends DetailEvents {
  const FetchDetailEvent({required this.id});

  final String id;
}
