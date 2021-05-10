import '../FirestoreDataSource.dart';
import '../entities/Event.dart';

class EventsRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Event>> fetchAllEvents() {
    return firestoreDataSource.db.collection('events').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.data()))
            .toList());
  }
}
