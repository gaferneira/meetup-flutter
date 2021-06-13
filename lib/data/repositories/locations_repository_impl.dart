import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meetup/models/location.dart';

import 'locations_repository.dart';

class LocationsRepositoryImpl extends LocationsRepository {
  final FirebaseFirestore firebaseFirestore;

  LocationsRepositoryImpl({required this.firebaseFirestore});

  @override
  Stream<List<Location>> fetchLocations() {
    return firebaseFirestore.collection('locations').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                Location.fromJson(documentSnapshot.data()))
            .toList());
  }
}
