import 'package:drill_events/common/network/http_api_client.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
final class Dependencies {
  late final Logger logger;
  late final FastCache fastCache;
  late final Pipe pipe;

  // Network
  late final HttpApiClient httpApiClient;

  // Data
  late final BackendAPI backendApi;
  late final SharedPreferences sharedPreferences;
  late final FlutterSecureStorage secureStorage;

  //File management
  late final ImagePicker imagePicker;
  late final FileStorage fileStorage;
}
