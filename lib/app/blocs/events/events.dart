///Events
sealed class Events {
  const Events._();
}

final class FetchEvents extends Events {
  const FetchEvents() : super._();
}

final class SearchEvents extends Events {
  const SearchEvents({required this.value}) : super._();

  final String value;
}
