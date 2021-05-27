import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreDataSource {
  static final FirestoreDataSource _singleton = FirestoreDataSource._internal();

  factory FirestoreDataSource() {
    return _singleton;
  }

  FirestoreDataSource._internal();

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
}
