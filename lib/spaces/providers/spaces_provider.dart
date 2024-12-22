import 'package:faker/faker.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/repositories/spaces_repository.dart';
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
      final spaces = await _repository.getSpaces();
      const defaultNotificationTimes = {
        "standard": [12, 24],
        "prioritized": [48],
      };
      spaces.add(Spaces(
        title: "Unassigned",
        id: null,
        spaceType: "office",
        notificationTimes: defaultNotificationTimes,
      ));

      if (isDebug) {
        spaces.add(Spaces(
          title: faker.animal.name(),
          spaceType: "office",
          notificationTimes: defaultNotificationTimes,
        ));

        spaces.add(Spaces(
          title: faker.animal.name(),
          spaceType: "living_room",
          notificationTimes: defaultNotificationTimes,
        ));

        spaces.add(
          Spaces(
            title: faker.animal.name(),
            spaceType: "school",
            notificationTimes: defaultNotificationTimes,
          ),
        );
      }

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

  Future<void> deleteSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteSpace(space);
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
