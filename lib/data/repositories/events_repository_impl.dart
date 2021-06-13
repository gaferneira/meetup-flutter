import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/event.dart';
import 'events_repository.dart';

class EventsRepositoryImpl extends EventsRepository {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  EventsRepositoryImpl({required this.firebaseFirestore, required this.firebaseStorage});

  @override
  Stream<List<Event>> fetchAllEvents() {
    return firebaseFirestore.collection('events').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.data()))
            .toList());
  }

  @override
  Stream<List<Event>> fetchAllEventsByCategory(String category) {
    return firebaseFirestore.collection('events').where("category", isEqualTo: category).snapshots().map(
            (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.data()))
            .toList());
  }

  @override
  Future<DocumentReference> addEvent(Event event) {
    return firebaseFirestore.collection('events').add(event.toJson());
  }

  @override
  Stream<TaskSnapshot> uploadImage(File file) {
    return firebaseStorage.ref().child('events/img_${DateTime.now().millisecondsSinceEpoch}').putFile(file).asStream();
  }
}
