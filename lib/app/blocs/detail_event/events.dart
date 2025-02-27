import 'package:drill_events/app/blocs/common_bloc_event.dart';

abstract class DetailEvents implements CommonBlocEvent {
  DetailEvents({this.publishToPipe = false});

  @override
  final bool publishToPipe;
}

final class FetchDetailEvent extends DetailEvents {
  FetchDetailEvent({required this.id});

  final String id;
}
