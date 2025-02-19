import 'package:drill_events/app/data/data_repository_interface.dart';
import 'package:drill_events/common/network/api_client.dart';

final class Dependencies {
  late final HttpApiClient httpApiClient;
  late final IDataRepository repository;
}
