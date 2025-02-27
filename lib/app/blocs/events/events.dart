import 'package:drill_events/app/blocs/common_bloc_event.dart';

abstract class Events implements CommonBlocEvent {
  Events({this.publishToPipe = false});

  @override
  final bool publishToPipe;
}

final class FetchEventsFeed extends Events {
  FetchEventsFeed();
}

final class SearchEvents extends Events {
  SearchEvents({required this.value});

  final String value;
}
