abstract class DetailEvents {}

final class FetchDetailEvent extends DetailEvents {
  FetchDetailEvent({required this.id});

  final String id;
}
