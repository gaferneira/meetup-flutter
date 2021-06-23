import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/event.dart';
import 'events_repository.dart';

class EventsRepositoryImpl extends EventsRepository {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth auth;

  EventsRepositoryImpl({required this.auth, required this.firebaseFirestore, required this.firebaseStorage});

  Stream<List<Event>> fetchAllEvents() {
    return firebaseFirestore.collection('events').snapshots().map(
            (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.id, documentSnapshot.data(), auth.currentUser))
            .toList());
  }

  Stream<List<Event>> fetchAllEventsByCategory(String category) {
    return firebaseFirestore.collection('events').where("category", isEqualTo: category).snapshots().map(
            (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Event.fromJson(documentSnapshot.id, documentSnapshot.data(), auth.currentUser))
            .toList());
  }

  Future<DocumentReference> addEvent(Event event) {
    event.owner = auth.currentUser?.email;
    return firebaseFirestore.collection('events').add(event.toJson());
  }

  Future<void> updateEvent(Event event) {
    return firebaseFirestore.collection('events').doc(event.documentId).update(event.toJson());
  }

  Future<TaskSnapshot> uploadImage(File file) {
    return firebaseStorage.ref().child('events/img_${DateTime.now().millisecondsSinceEpoch}').putFile(file);
  }

  @override
  Future<bool> addFavorite(Event event) async {
    var array = [auth.currentUser!.email];
    firebaseFirestore.collection('events').doc(event.documentId).update(
        {"saved": FieldValue.arrayUnion(array)}
    );
    return true;
  }

  @override
  Future<bool> removeFavorite(Event event) async {
    var array = [auth.currentUser!.email];
    firebaseFirestore.collection('events').doc(event.documentId).update(
        {"saved": FieldValue.arrayRemove(array)}
    );
    return true;
  }

  @override
  Future<bool> subscribe(Event event) async{
    var array = [auth.currentUser!.email];
    firebaseFirestore.collection('events').doc(event.documentId).update(
        {"participants": FieldValue.arrayUnion(array)}
    );
    return true;
  }

  @override
  Future<bool> unsubscribe(Event event) async{
    var array = [auth.currentUser!.email];
    firebaseFirestore.collection('events').doc(event.documentId).update(
        {"participants": FieldValue.arrayRemove(array)}
    );
    return true;
  }
}
