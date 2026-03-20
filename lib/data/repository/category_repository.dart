import '../database/database_helper.dart';
import '../database/models/CategoryModel.dart';

class CategoryRepository {

  Future<List<CategoryModel>> getCategories() async {

    final db = await DatabaseHelper.instance.database;

    final result = await db.query('Category');

    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

}