import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/app/models/org.dart';
import 'package:drill_events/app/models/spot.dart';
import 'package:drill_events/app/models/user.dart';

abstract interface class DataRepository {
  //Events
  Future<Iterable<EventModel>> fetchEvents();
  Future<Iterable<EventModel>> searchEvents(String value);
  Future<String> signUpToEvent(String email);
  //TODO
  Future<EventModel> getDetailEvent(String eventId);

  //User
  Future<String> createUser({required String email, required String password});
  Future<UserModel> fetchUserInfo(String uid);
  Future<void> updateUserInfo(); //TODO: передавать модель с данными в параметрах

  //Spots
  Future<SpotModel> getSpot(String spotId);
  Future<List<EventModel>> getSpotEvents(String spotId);

  //Org
  Future<OrgModel> getOrg(String orgId);
  Future<List<EventModel>> getOrgEvents(String orgId);
  Future<List<SpotModel>> getOrgSpots(String orgId);

  //Auth
  Future<String?> getJwtToken();
  Future<void> refreshJwt();
}
