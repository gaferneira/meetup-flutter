import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firestore_data_source.dart';
import '../../models/event.dart';

class EventsRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Event>> fetchAllEvents() {
    return firestoreDataSource.db.collection('events').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.data()))
            .toList());
  }

  Stream<List<Event>> fetchAllEventsByCategory(String category) {
    return firestoreDataSource.db.collection('events').where("category", isEqualTo: category).snapshots().map(
            (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.data()))
            .toList());
  }

  Future<DocumentReference> addEvent(Event event) {
    return firestoreDataSource.db.collection('events').add(event.toJson());
  }

  Future<TaskSnapshot> uploadImage(File file) {
    return firestoreDataSource.storage.ref().child('events/img_${DateTime.now().millisecondsSinceEpoch}').putFile(file);
  }
}
