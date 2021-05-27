import 'package:flutter_meetup/models/location.dart';

import '../firestore_data_source.dart';

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
