import 'package:flutter/foundation.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/repositories/spaces_repository.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final spacesProvider = ChangeNotifierProvider((ref) => SpacesProvider());

class SpacesProvider extends ChangeNotifier {
  Spaces? _space;
  Spaces? get space => _space;

  final SpacesRepository _repository = SpacesRepository();

  List<Spaces> _spacesList = [];
  List<Spaces> get allSpaces => _spacesList;

  bool readOnly = true;

  SpacesProvider() {
    _fetchAllSpaces();
  }

  Future<ReturnModel> _fetchAllSpaces() async {
    try {
      final result = await _repository.getSpaces();
      _spacesList = result;
      notifyListeners();

      return ReturnModel(
          data: _spacesList,
          message: "Spaces fetched successfully",
          success: true);
    } catch (e) {
      return ReturnModel(
          message: "Error fetching spaces",
          success: false,
          error: e.toString());
    }
  }

  Future<ReturnModel> fetchSpace(int id) async {
    try {
      final result = await _repository.getSpace(id);
      _space = result;
      notifyListeners();

      return ReturnModel(
          data: _space,
          message: "Space fetched successfully",
          success: true);
    } catch (e) {
      return ReturnModel(
          message: "Error fetching space",
          success: false,
          error: e.toString());
    }
  }

  Future<ReturnModel> createSpace(Spaces space) async {
    try {
      final result = await _repository.createSpace(space);
      _spacesList.add(result.data);
      notifyListeners();

      return ReturnModel(
          data: result.data,
          message: "Space created successfully",
          success: true);
    } catch (e) {
      return ReturnModel(
          message: "Error creating space",
          success: false,
          error: e.toString());
    }
  }

  Future<ReturnModel> updateSpace(Spaces space) async {
    try {
      final result = await _repository.updateSpace(space);
      _spacesList[_spacesList.indexWhere((element) => element.id == result.data.id)] = result.data;
      notifyListeners();

      return ReturnModel(
          data: result.data,
          message: "Space updated successfully",
          success: true);
    } catch (e) {
      return ReturnModel(
          message: "Error updating space",
          success: false,
          error: e.toString());
    }
  }

  onDispose() {
    // Update all the repositories
  }
}


