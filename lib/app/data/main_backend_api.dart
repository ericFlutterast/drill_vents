import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/pipe.dart';

class MainBackendAPI implements BackendAPI {
  const MainBackendAPI({required HttpApiClient api, required Pipe pipe}) : _pipe = pipe, _api = api;

  final HttpApiClient _api;
  final Pipe _pipe;

  @override
  Future<List<CityModel>> getCities() async {
    final response = await _api.post('/cities');
    final items = response.data['cities'] as List;
    return items.map((e) => CityModel.fromJson(e)).toList();
  }

  @override
  Future<SessionModel> createSession(String email, String password) async {
    final response = await _api.post('/sessions', data: {'email': email, 'password': password});
    final item = response.data['session'] as Map<String, dynamic>;
    return SessionModel.fromJson(item);
  }

  @override
  Future<SessionModel> refreshSession() async {
    final response = await _api.patch('/sessions');
    final item = response.data['session'] as Map<String, dynamic>;
    return SessionModel.fromJson(item);
  }

  // Profile

  @override
  Future<String> createUser({required String email, required String password}) async {
    final response = await _api.post('/users', data: {'email': email, 'password': password});
    return response.data['user_id'] as String;
  }

  @override
  Future<UserModel> getMyProfile() async {
    final response = await _api.get('/users/me');
    final item = response.data['user'] as Map<String, dynamic>;
    return UserModel.fromJson(item);
  }

  @override
  Future<void> updateMyProfile({
    String? name,
    String? email,
    String? phone,
    String? telegram,
    String? whatsapp,
    String? vk,
  }) async {
    final data = {'name': name, 'phone': phone, 'telegram': telegram, 'whatsapp': whatsapp, 'vk': vk, 'email': email};
    await _api.patch('/users', data: data);
  }

  @override
  Future<List<OrgCardModel>> getMyOrgs() async {
    final response = await _api.get('/users/me/orgs');
    final items = response.data['orgs'] as List;
    return items.map((e) => OrgCardModel.fromJson(e)).toList();
  }

  @override
  Future<List<SpotCardModel>> getMySubscriptions() async {
    final response = await _api.get('/users/me/spots');
    final items = response.data['spots'] as List;
    return items.map((e) => SpotCardModel.fromJson(e)).toList();
  }

  // Events

  @override
  Future<(List<EventCardModel>, PaginationModel)> getEvents({
    required int page,
    String? search,
    int size = 10,
    bool subs = false,
  }) async {
    final response = await _api.get(
      '/events',
      queryParameters: {'page': page, 'size': size, 'search': search, 'subs': subs},
    );

    final rawEvents = response.data['events'] as List;
    final events = rawEvents.map((e) => EventCardModel.fromJson(e)).toList();

    final rawPagination = response.data['pagination'] as Map<String, dynamic>;
    final pagination = PaginationModel.fromJson(rawPagination);

    return (events, pagination);
  }

  @override
  Future<DetailEventModel> getEvent(String id) async {
    final response = await _api.get('/events/$id');
    final item = response.data['event'] as Map<String, dynamic>;
    return DetailEventModel.fromJson(item);
  }

  @override
  Future<List<ShortUserModel>> getParticipants(String id) async {
    final response = await _api.get('/events/$id/participants');
    final items = response.data['participants'] as List?;
    return items?.map((e) => ShortUserModel.fromJson(e)).toList() ?? [];
  }

  @override
  Future<DetailEventModel> createEvent(NewEventModel eventData) async {
    final data = eventData.toJson();

    final response = await _api.post('/events', data: data);
    final item = response.data['event'] as Map<String, dynamic>;

    return DetailEventModel.fromJson(item);
  }

  @override
  Future<DetailEventModel> updateEvent(String id, {required NewEventModel eventData}) async {
    final date = eventData.toJson();

    final response = await _api.patch('/events/$id', data: date);
    final item = response.data['event'] as Map<String, dynamic>;

    return DetailEventModel.fromJson(item);
  }

  @override
  Future<(SessionModel, BookingModel)> createAuthorizeAndBook({
    required String email,
    required String password,
    required String eventId,
  }) async {
    final response = await _api.post('/cab', data: {"email": email, "password": password, "event_id": eventId});

    final rawBooking = response.data['booking'] as Map<String, dynamic>;
    final booking = BookingModel.fromJson(rawBooking);

    _pipe.publish(BookPipeEvent(booking));

    final rawSession = response.data['session'] as Map<String, dynamic>;
    final session = SessionModel.fromJson(rawSession);

    return (session, booking);
  }

  // Orgs

  @override
  Future<DetailOrgModel> getOrg(String id) async {
    final response = await _api.get('/orgs/$id');
    final item = response.data['org'] as Map<String, dynamic>;
    return DetailOrgModel.fromJson(item);
  }

  @override
  Future<List<SpotCardModel>> getOrgSpots(String id) async {
    final response = await _api.get('/orgs/$id/spots');
    final items = response.data['spots'] as List;
    return items.map((e) => SpotCardModel.fromJson(e)).toList();
  }

  @override
  Future<List<EventCardModel>> getOrgEvents(String id) async {
    final response = await _api.get('/orgs/$id/events');
    final items = response.data['events'] as List;
    return items.map((e) => EventCardModel.fromJson(e)).toList();
  }

  // Spots

  @override
  Future<DetailSpotModel> getSpot(String id) async {
    final response = await _api.get('/spots/$id');
    final item = response.data['spot'] as Map<String, dynamic>;
    return DetailSpotModel.fromJson(item);
  }

  @override
  Future<List<EventCardModel>> getSpotEvents(String id) async {
    final response = await _api.get('/spots/$id/events');
    final items = response.data['events'] as List;
    return items.map((e) => EventCardModel.fromJson(e)).toList();
  }

  @override
  Future subscribeToSpot(String id) => _api.post('/spots/$id/subscription');
  @override
  Future unsubscribeFromSpot(String id) => _api.delete('/spots/$id/subscription');

  // Bookings

  @override
  Future<BookingModel> getBookingStatus(String eventId, String usrId) async {
    final response = await _api.get('/bookings/events/$eventId/status', queryParameters: {'usr_id': usrId});
    final item = response.data['booking'] as Map<String, dynamic>;
    return BookingModel.fromJson(item);
  }

  @override
  Future<BookingModel> bookEvent(String eventId, String usrId) async {
    final response = await _api.post(
      '/bookings/events/$eventId/status',
      queryParameters: {'usr_id': usrId, 'action': 'book'},
    );
    final item = response.data['booking'] as Map<String, dynamic>;
    return BookingModel.fromJson(item);
  }

  @override
  Future<BookingModel> approveBooking(String eventId, String usrId) async {
    final response = await _api.post(
      '/bookings/events/$eventId/status',
      queryParameters: {'usr_id': usrId, 'action': 'approve'},
    );
    final item = response.data['booking'] as Map<String, dynamic>;
    return BookingModel.fromJson(item);
  }

  @override
  Future<BookingModel> rejectBooking(String eventId, String usrId, String reason) async {
    final response = await _api.post(
      '/bookings/events/$eventId/status',
      queryParameters: {'usr_id': usrId, 'action': 'reject', 'reason': reason},
    );
    final item = response.data['booking'] as Map<String, dynamic>;
    return BookingModel.fromJson(item);
  }

  //Roles

  @override
  Future<Iterable<RoleModel>> getUserRoles() async {
    final response = await _api.get('/users/me/roles');
    final roles = response.data['roles'] as List;
    return roles.map((element) => RoleModel.fromJson(element));
  }

  @override
  Future<Iterable<ShortUserModel>> getUserForModeration(String eventId) async {
    final response = await _api.get('/bookings/events/$eventId/moderation');
    final users = response.data['bookings'] as List;
    return users.map((json) => ShortUserModel.fromJson(json));
  }
}
