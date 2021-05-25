import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSource {
  static final FirestoreDataSource _singleton = FirestoreDataSource._internal();

  factory FirestoreDataSource() {
    return _singleton;
  }

  FirestoreDataSource._internal();

  FirebaseFirestore db = FirebaseFirestore.instance;
}
