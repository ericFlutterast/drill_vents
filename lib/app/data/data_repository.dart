import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/common/network/api_client.dart';

final class DataRepositoryImpl implements IDataRepository {
  const DataRepositoryImpl(this._apiClient);

  final HttpApiClient _apiClient;

  //Events
  @override
  Future<Iterable<EventModel>> fetchEvents() async {
    final response = await _apiClient.request(RequestType.get(path: '/events/feed'));

    final data = response.data['events'];

    return (data as List).map((item) => EventModel.fromJson(item));
  }

  @override
  Future<Iterable<EventModel>> searchEvents(String value) async {
    final queryParameters = {'search': value};

    final response = await _apiClient.request(RequestType.get(path: '/events', queryParameters: queryParameters));

    final data = response.data['events'];

    return (data as List).map((item) => EventModel.fromJson(item));
  }

  @override
  Future<Object> getDetailEvent(String eventId) async {
    final response = await _apiClient.request(RequestType.get(path: '/events/$eventId'));

    return Object();
  }

  @override
  Future<void> signUpToEvent(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  //User
  @override
  Future<void> createUser({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserInfo() {
    throw UnimplementedError();
  }

  @override
  Future<Object> fetchUserInfo() {
    throw UnimplementedError();
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
  Future<Object> fetchSpot(String spotId) {
    throw UnimplementedError();
  }

  @override
  Future<Object> fetchSpotEvents(String spotId) {
    throw UnimplementedError();
  }
}
