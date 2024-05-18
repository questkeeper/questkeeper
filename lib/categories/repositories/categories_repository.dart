import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesRepository {
  CategoriesRepository();
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Categories>> getCategories() async {
    final categories =
        await supabase.from('categories').select().eq('archived', false);

    final categoriesList =
        categories.map((e) => Categories.fromJson(e)).toList();

    return categoriesList;
  }

  Future<ReturnModel> updateCategory(Categories category) async {
    final jsonCategory = category.toJson();
    final int id = jsonCategory["id"];

    try {
      final result = await supabase
          .from('categories')
          .update(jsonCategory)
          .eq('id', id)
          .select();

      return ReturnModel(
          message: "Category updated successfully",
          success: true,
          data: result.first);
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

    try {
      final result =
          await supabase.from('categories').insert(jsonCategory).select();

      return ReturnModel(
          message: "Category created successfully",
          success: true,
          data: result.first);
    } catch (error) {
      return ReturnModel(
          message: "Error creating category",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteCategory(Categories category) async {
    try {
      await supabase.from('categories').delete().eq('id', category.id!);

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
