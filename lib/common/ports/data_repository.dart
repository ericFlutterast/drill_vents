import 'package:drill_events/app/models/event_model.dart';

abstract interface class DataRepository {
  //Events
  Future<Iterable<EventModel>> fetchEvents();
  Future<Iterable<EventModel>> searchEvents(String value);
  Future<void> signUpToEvent(String email);
  //TODO
  Future<EventModel> getDetailEvent(String eventId);

  //User
  Future<void> createUser({required String email, required String password});
  Future<Object> fetchUserInfo();
  Future<void> updateUserInfo(); //TODO: передавать модель с данными в параметрах

  //Spots
  Future<Object> fetchSpot(String spotId);
  Future<Object> fetchSpotEvents(String spotId);

  //Org
  Future<Object> fetchOrganizationInfo(String organizationId);
  Future<Object> fetchOrganizationSpots(String organizationId);
  Future<Object> fetchOrganizationEvents(String organizationId);
}
