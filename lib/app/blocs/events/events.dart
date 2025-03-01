abstract class Events {}

final class FetchEventsFeed extends Events {
  FetchEventsFeed();
}

final class SearchEvents extends Events {
  SearchEvents({required this.value});

  final String value;
}
