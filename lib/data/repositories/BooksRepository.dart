import '../FirestoreDataSource.dart';
import '../entities/Book.dart';

class BooksRepository {
  final FirestoreDataSource firestoreDataSource = FirestoreDataSource();

  Stream<List<Book>> fetchAllBooks() {
    return firestoreDataSource.db.collection('books').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Book.fromJson(documentSnapshot.data()))
            .toList());
  }
}
