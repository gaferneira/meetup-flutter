import '../FirestoreDataSource.dart';
import '../entities/Category.dart';

class CategoriesRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Category>> fetchCategories() {
    return firestoreDataSource.db.collection('categories').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                Category.fromJson(documentSnapshot.data()))
            .toList());
  }
}
