import 'package:flutter_meetup/models/location.dart';

abstract class LocationsRepository {
  Stream<List<Location>> fetchLocations();
}
