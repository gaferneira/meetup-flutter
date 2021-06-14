import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meetup/data/repositories/categories_respository.dart';

import '../../models/category.dart';

class CategoriesRepositoryImpl extends CategoriesRepository {

  final FirebaseFirestore firebaseFirestore;

  CategoriesRepositoryImpl({required this.firebaseFirestore});

  @override
  Stream<List<Category>> fetchCategories() {
    return firebaseFirestore.collection('categories').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                Category.fromJson(documentSnapshot.data()))
            .toList());
  }
}
