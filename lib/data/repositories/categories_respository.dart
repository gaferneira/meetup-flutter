import '../../models/category.dart';

abstract class CategoriesRepository {
  Stream<List<Category>> fetchCategories();
}
