import 'package:drill_events/app/new_models/models.dart';

abstract interface class BackendAPI {
  Future<Iterable<CityModel>> getCities();
  Future<SessionModel> createSession(String email, String password);
  Future<SessionModel> refreshSession();
  Future<String> createUser({required String email, required String password});
  Future<UserModel> getMyProfile();
  Future updateMyProfile({String? name, String? email, String? phone, String? telegram, String? whatsapp, String? vk});
  Future<Iterable<OrgCardModel>> getMyOrgs();
  Future<Iterable<SpotCardModel>> getMySubscriptions();
  Future<(Iterable<EventCardModel>, PaginationModel)> getEvents({
    required int page,
    String? search,
    int size = 10,
    bool subs = false,
  });
  Future<DetailEventModel> getEvent(String id);
  Future<Iterable<ShortUserModel>> getParticipants(String id);
  Future<DetailEventModel> createEvent(NewEventModel eventData);
  Future<DetailEventModel> updateEvent(String id, {required NewEventModel eventData});
  Future<(SessionModel, BookingModel)> createAuthorizeAndBook({
    required String email,
    required String password,
    required String eventId,
  });
  Future<DetailOrgModel> getOrg(String id);
  Future<Iterable<SpotCardModel>> getOrgSpots(String id);
  Future<Iterable<EventCardModel>> getOrgEvents(String id);
  Future<DetailSpotModel> getSpot(String id);
  Future<Iterable<EventCardModel>> getSpotEvents(String id);
  Future subscribeToSpot(String id);
  Future unsubscribeFromSpot(String id);
  Future<BookingModel> getBookingStatus(String eventId, String usrId);
  Future<BookingModel> bookEvent(String eventId, String usrId);
  Future<BookingModel> approveBooking(String eventId, String usrId);
  Future<BookingModel> rejectBooking(String eventId, String usrId, String reason);
}
