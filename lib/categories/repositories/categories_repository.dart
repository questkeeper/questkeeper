import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

class CategoriesRepository {
  CategoriesRepository();
  final HttpService _httpService = HttpService();

  Future<List<Categories>> getCategories() async {
    final response = await _httpService.get('/core/categories');

    final List<dynamic> data = response.data;
    final List<Categories> categoriesList =
        data.map((e) => Categories.fromJson(e)).toList();

    return categoriesList;
  }

  Future<ReturnModel> updateCategory(Categories category) async {
    final jsonCategory = category.toJson();

    jsonCategory.remove('createdAt');
    jsonCategory.remove('updatedAt');
    jsonCategory.remove('tasks');

    try {
      final result = await _httpService.put('/core/categories/${category.id}',
          data: jsonCategory);

      return ReturnModel(
          message: "Category updated successfully",
          success: true,
          data: result);
    } catch (error) {
      return ReturnModel(
          message: "Error updating category",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> createCategory(Categories category) async {
    final jsonCategory = category.toJson();

    jsonCategory.remove('id');
    jsonCategory.remove('createdAt');
    jsonCategory.remove('updatedAt');
    jsonCategory.remove('tasks');

    try {
      final result =
          await _httpService.post('/core/categories', data: jsonCategory);

      return ReturnModel(
        message: "Category created successfully",
        success: true,
        data: result.data,
      );
    } catch (error) {
      return ReturnModel(
          message: "Error creating category",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteCategory(Categories category) async {
    try {
      await _httpService.delete('/core/categories/${category.id}');

      return const ReturnModel(
          message: "Category deleted successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting category",
          success: false,
          error: error.toString());
    }
  }
}
