import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

class SpacesRepository {
  SpacesRepository();

  final supabase = Supabase.instance.client;
  final HttpService _httpService = HttpService();

  Future<List<Spaces>> getSpaces() async {
    final response = await _httpService.get('/core/spaces');

    final List<dynamic> data = response.data;
    final List<Spaces> spacesList = data.map((e) => Spaces.fromMap(e)).toList();
    return spacesList;
  }

  Future<ReturnModel> createSpace(Spaces space) async {
    final Map<String, dynamic> jsonSpace = space.toMap();
    jsonSpace.remove("id");
    jsonSpace.remove("tasks");
    jsonSpace.remove("categories");

    try {
      final newSpace = await _httpService.post('/core/spaces', data: jsonSpace);
      final data = newSpace.data;

      return ReturnModel(
          data: Spaces.fromMap(data),
          message: "Space created successfully",
          success: true);
    } catch (error) {
      debugPrint("Error creating space: $error");
      return ReturnModel(
          message: "Error creating space item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateSpace(Spaces space) async {
    final Map<String, dynamic> jsonSpace = space.toMap();
    jsonSpace.remove("created_at");
    jsonSpace.remove("updatedAt");

    try {
      final updatedSpace =
          await _httpService.put('/core/spaces/${space.id}', data: jsonSpace);
      final data = updatedSpace.data;

      debugPrint("Updated space: $data");

      return ReturnModel(
          data: Spaces.fromMap(data),
          message: "Space updated successfully",
          success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error updating space item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteSpace(Spaces space) async {
    try {
      await _httpService.delete('/core/spaces/${space.id}');

      return const ReturnModel(
          message: "Space deleted successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting space item",
          success: false,
          error: error.toString());
    }
  }
}
