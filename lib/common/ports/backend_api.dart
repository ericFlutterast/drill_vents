import 'package:drill_events/app/new_models/models.dart';

abstract interface class BackendAPI {
  Future<List<CityModel>> getCities();
  Future<SessionModel> createSession(String email, String password);
  Future<SessionModel> refreshSession();
  Future<String> createUser({required String email, required String password});
  Future<UserModel> getMyProfile();
  Future updateMyProfile({String? name, String? email, String? phone, String? telegram, String? whatsapp, String? vk});
  Future<List<OrgCardModel>> getMyOrgs();
  Future<List<SpotCardModel>> getMySubscriptions();
  Future<(List<EventCardModel>, PaginationModel)> getEvents({
    required int page,
    String? search,
    int size = 10,
    bool subs = false,
  });
  Future<DetailEventModel> getEvent(String id);
  Future<List<ShortUserModel>> getParticipants(String id);
  Future<DetailEventModel> createEvent(NewEventModel eventData);
  Future<DetailEventModel> updateEvent(
    String id, {
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? startTime,
    DateTime? endTime,
  });
  Future<(SessionModel, BookingModel)> createAuthorizeAndBook({
    required String email,
    required String password,
    required String eventId,
  });
  Future<DetailOrgModel> getOrg(String id);
  Future<Iterable<SpotCardModel>> getOrgSpots(String id);
  Future<List<EventCardModel>> getOrgEvents(String id);
  Future<DetailSpotModel> getSpot(String id);
  Future<List<EventCardModel>> getSpotEvents(String id);
  Future subscribeToSpot(String id);
  Future unsubscribeFromSpot(String id);
  Future<BookingModel> getBookingStatus(String eventId, String usrId);
  Future<BookingModel> bookEvent(String eventId, String usrId);
  Future<BookingModel> approveBooking(String eventId, String usrId);
  Future<BookingModel> rejectBooking(String eventId, String usrId, String reason);
}
