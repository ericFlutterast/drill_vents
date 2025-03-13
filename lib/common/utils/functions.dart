import 'package:drill_events/app/new_models/models.dart';

CityModel? findCity(List<CityModel> cities, int id) {
  cities.sort((a, b) => a.id.compareTo(b.id));

  List<CityModel> temporary = [...cities];
  while (temporary.isNotEmpty) {
    final centralElement = temporary[cities.length ~/ 2];
    if (centralElement.id == id) {
      return centralElement;
    }
    if (id > centralElement.id) {
      temporary = temporary.sublist(cities.length ~/ 2, temporary.length - 1);
    } else {
      temporary = temporary.sublist(0, cities.length ~/ 2);
    }
  }

  return null;
}
