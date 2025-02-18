import 'package:drill_events/app/models/event_model.dart';

abstract interface class IDataRepository {
  Future<Iterable<EventModel>> fetchEvents();
}
