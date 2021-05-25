import 'package:flutter_meetup/model/entities/Location.dart';

import '../FirestoreDataSource.dart';

class LocationsRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Location>> fetchLocations() {
    return firestoreDataSource.db.collection('locations').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                Location.fromJson(documentSnapshot.data()))
            .toList());
  }
}
