import 'package:drill_events/app/models/event.dart';
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
  Future<UserModel> fetchUserInfo(String token) async {
    await Future.delayed(const Duration(seconds: 2));
    //final result = await _apiClient.get('/user');
    //final data = result.data;
    return const UserModel(
      userId: 'fake_id',
      name: 'Drill Master',
      phone: '+7 888 333 11 22',
      telegram: '@drillGuyy',
      email: '09erik07@gmail.com',
      imgUrl: '',
      instagram: '',
      vk: '',
      whatsApp: '',
    );
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

  //Auth
  @override
  Future<String> getJwtToken() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'drill_wt';
  }

  @override
  Future<void> refreshJwt() async {
    throw UnimplementedError();
  }
}
