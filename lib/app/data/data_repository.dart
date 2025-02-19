import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/common/network/api_client.dart';
import 'package:drill_events/common/network/endpoints.dart';

final class DataRepositoryImpl implements IDataRepository {
  const DataRepositoryImpl(this._apiClient);

  final HttpApiClient _apiClient;

  @override
  Future<Iterable<EventModel>> fetchEvents() async {
    final response = await _apiClient.request(RequestType.get(path: Endpoints.eventsFeed));

    final data = response.data['events'];

    return (data as List).map((item) => EventModel.fromJson(item));
  }
}
