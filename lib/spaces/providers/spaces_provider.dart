import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/utils/undo_manager_mixin.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/repositories/spaces_repository.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager
    with UndoManagerMixin<List<Spaces>> {
  final SpacesRepository _repository;
  List<Spaces>? _cachedSpaces;
  bool _hasUnassignedItems = false;

  SpacesManager() : _repository = SpacesRepository();

  @override
  FutureOr<List<Spaces>> build() async {
    // Only rebuild when the unassigned status changes, not on every task/category change
    ref.listen(
        tasksManagerProvider.select((value) => value.whenData((tasks) {
              final hasUnassigned = tasks.any((task) => task.spaceId == null);
              if (hasUnassigned != _hasUnassignedItems) {
                _hasUnassignedItems = hasUnassigned;
                _updateUnassignedSpace();
              }
              return hasUnassigned;
            })),
        (_, __) {});

    ref.listen(
        categoriesManagerProvider
            .select((value) => value.whenData((categories) {
                  final hasUnassigned =
                      categories.any((category) => category.spaceId == null);
                  if (hasUnassigned != _hasUnassignedItems) {
                    _hasUnassignedItems = hasUnassigned;
                    _updateUnassignedSpace();
                  }
                  return hasUnassigned;
                })),
        (_, __) {});

    if (_cachedSpaces == null || _cachedSpaces!.isEmpty) {
      return fetchSpaces();
    }
    return _cachedSpaces!;
  }

  void _updateUnassignedSpace() {
    if (_cachedSpaces == null) return;

    if (_hasUnassignedItems &&
        !_cachedSpaces!.any((space) => space.id == null)) {
      _cachedSpaces = [..._cachedSpaces!, _createUnassignedSpace()];
      state = AsyncValue.data(_cachedSpaces!);
    } else if (!_hasUnassignedItems &&
        _cachedSpaces!.any((space) => space.id == null)) {
      _cachedSpaces =
          _cachedSpaces!.where((space) => space.id != null).toList();
      state = AsyncValue.data(_cachedSpaces!);
    }
  }

  Spaces _createUnassignedSpace() {
    const defaultNotificationTimes = {
      "standard": [12, 24],
      "prioritized": [48],
    };
    return Spaces(
      title: "Unassigned",
      id: null,
      spaceType: "office",
      notificationTimes: defaultNotificationTimes,
    );
  }

  Future<List<Spaces>> fetchSpaces() async {
    try {
      final spaces = await _repository.getSpaces();

      if (_hasUnassignedItems || spaces.isEmpty) {
        spaces.add(_createUnassignedSpace());
      }

      _cachedSpaces = spaces;
      return spaces;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> createSpace(Spaces space) async {
    try {
      await _repository.createSpace(space);
      final spaces = await _repository.getSpaces();
      if (_hasUnassignedItems) {
        spaces.add(_createUnassignedSpace());
      }
      _cachedSpaces = spaces;
      state = AsyncValue.data(spaces);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpace(Spaces space) async {
    try {
      await _repository.updateSpace(space);
      final spaces = await _repository.getSpaces();
      if (_hasUnassignedItems) {
        spaces.add(_createUnassignedSpace());
      }
      _cachedSpaces = spaces;
      state = AsyncValue.data(spaces);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteSpace(Spaces space) async {
    final oldSpaces = _cachedSpaces ?? state.value!;
    final newSpaces =
        oldSpaces.where((element) => element.id != space.id).toList();

    performActionWithUndo(
      UndoAction(
        previousState: oldSpaces,
        newState: newSpaces,
        repositoryAction: () async {
          await _repository.deleteSpace(space);
          final spaces = await _repository.getSpaces();
          if (_hasUnassignedItems) {
            spaces.add(_createUnassignedSpace());
          }
          _cachedSpaces = spaces;
          state = AsyncValue.data(spaces);
        },
        successMessage: "Space deleted",
        timing: ActionTiming.afterUndoPeriod,
        postUndoAction: () async {
          final spaces = await _repository.getSpaces();
          if (_hasUnassignedItems) {
            spaces.add(_createUnassignedSpace());
          }
          _cachedSpaces = spaces;
          state = AsyncValue.data(spaces);
        },
      ),
    );
  }

  Future<void> refreshSpaces() async {
    try {
      final spaces = await _repository.getSpaces();
      if (_hasUnassignedItems || spaces.isEmpty) {
        spaces.add(_createUnassignedSpace());
      }
      _cachedSpaces = spaces;
      state = AsyncValue.data(spaces);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
