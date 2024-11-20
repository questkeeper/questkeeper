import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';

class SpacesRepository {
  SpacesRepository();

  final supabase = Supabase.instance.client;

  Future<List<Spaces>> getSpaces() async {
    final spaces = await supabase.from("spaces").select().order("created_at");

    final List<Spaces> spacesList =
        spaces.map((e) => Spaces.fromMap(e)).toList();

    return spacesList;
  }

  Future<Spaces> getSpace(int id) async {
    final space = await supabase.from("spaces").select().eq("id", id).single();

    return Spaces.fromMap(space);
  }

  Future<ReturnModel> createSpace(Spaces space) async {
    final Map<String, dynamic> jsonSpace = space.toMap();
    jsonSpace.remove("id");
    jsonSpace.remove("tasks");
    jsonSpace.remove("categories");

    try {
      final newSpace =
          await supabase.from("spaces").insert(jsonSpace).select().single();

      debugPrint("New space: $newSpace");

      return ReturnModel(
          data: Spaces.fromMap(newSpace),
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
    jsonSpace.remove("updated_at");

    try {
      final updatedSpace = await supabase
          .from("spaces")
          .update(jsonSpace)
          .eq("id", space.id!)
          .select()
          .single();

      debugPrint("Updated space: $updatedSpace");

      return ReturnModel(
          data: Spaces.fromMap(updatedSpace),
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
      await supabase.from("spaces").delete().eq("id", space.id!);

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
