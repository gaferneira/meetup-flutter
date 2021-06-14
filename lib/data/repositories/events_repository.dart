import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/event.dart';

abstract class EventsRepository {
  Stream<List<Event>> fetchAllEvents();
  Stream<List<Event>> fetchAllEventsByCategory(String category);
  Future<DocumentReference> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<TaskSnapshot> uploadImage(File file);
}
