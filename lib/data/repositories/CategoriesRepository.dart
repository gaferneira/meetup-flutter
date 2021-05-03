import '../FirestoreDataSource.dart';
import '../entities/Categories.dart';

class CategoriesRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Categories>> fetchCategories() {
    return firestoreDataSource.db.collection('categories').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                Categories.fromJson(documentSnapshot.data()))
            .toList());
  }
}
