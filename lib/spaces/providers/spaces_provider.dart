import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/repositories/spaces_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager {
  final SpacesRepository _repository;

  SpacesManager() : _repository = SpacesRepository();

  @override
  FutureOr<List<Spaces>> build() async {
    return fetchSpaces();
  }

  Future<List<Spaces>> fetchSpaces() async {
    try {
      var spaces = await _repository.getSpaces();
      spaces.add(const Spaces(title: "Unassigned", id: null));
      return spaces;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> createSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createSpace(space);
      await refreshSpaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateSpace(space);
      await refreshSpaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshSpaces() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ref.refresh(spacesManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
