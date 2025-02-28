import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/app/models/spot.dart';
import 'package:drill_events/app/models/user.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:drill_events/common/ports/data_repository.dart';

final class BackendDataRepository implements DataRepository {
  const BackendDataRepository(this._apiClient);

  final HttpApiClient _apiClient;

  //Events
  @override
  Future<Iterable<EventModel>> fetchEvents() async {
    final response = await _apiClient.get('/events/feed');
    final data = response.data['events'];
    return (data as List).map((item) => EventModel.fromJson(item));
  }

  @override
  Future<Iterable<EventModel>> searchEvents(String value) async {
    final queryParameters = {'search': value};
    final response = await _apiClient.get('/events', queryParameters: queryParameters);
    final data = response.data['events'];
    return (data as List).map((item) => EventModel.fromJson(item));
  }

  @override
  Future<EventModel> getDetailEvent(String eventId) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await _apiClient.get('/events/$eventId');
    return EventModel.fromJson(response.data['event']);
  }

  @override
  Future<String> signUpToEvent(String email) async {
    //TODO:
    await Future.delayed(const Duration(seconds: 5));
    return 'success';
  }

  //User
  @override
  Future<String> createUser({required String email, required String password}) async {
    final body = {'email': email, 'password': password};
    final response = await _apiClient.post('/users', data: body);
    var userId = '';
    if (response.data case {'user_id': String id}) {
      userId = id;
    }
    return userId;
  }

  @override
  Future<void> updateUserInfo() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> fetchUserInfo(String uid) async {
    final result = await _apiClient.get('/users/$uid');
    final data = result.data['user'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  //Org
  @override
  Future<Object> fetchOrganizationEvents(String organizationId) {
    throw UnimplementedError();
  }

  @override
  Future<Object> fetchOrganizationInfo(String organizationId) {
    throw UnimplementedError();
  }

  @override
  Future<Object> fetchOrganizationSpots(String organizationId) {
    throw UnimplementedError();
  }

  //Spots
  @override
  Future<SpotModel> getSpot(String spotId) async {
    final response = await _apiClient.get('/spots/$spotId');
    final rawSpot = response.data['spot'] as Map<String, dynamic>;
    return SpotModel.fromJson(rawSpot);
  }

  @override
  Future<List<EventModel>> getSpotEvents(String spotId) async {
    final response = await _apiClient.get('/spots/$spotId/events');
    final rawEvents = response.data['events'] as List;
    return rawEvents.map((e) => EventModel.fromJson(e)).toList();
  }

  //Auth
  @override
  Future<String?> getJwtToken() async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  @override
  Future<void> refreshJwt() async {
    throw UnimplementedError();
  }
}
