// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TasksManager)
const tasksManagerProvider = TasksManagerProvider._();

final class TasksManagerProvider
    extends $AsyncNotifierProvider<TasksManager, List<Tasks>> {
  const TasksManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tasksManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tasksManagerHash();

  @$internal
  @override
  TasksManager create() => TasksManager();
}

String _$tasksManagerHash() => r'21d9b6a9e9a37b89f57d9065b4287388c3ac217f';

abstract class _$TasksManager extends $AsyncNotifier<List<Tasks>> {
  FutureOr<List<Tasks>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Tasks>>, List<Tasks>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Tasks>>, List<Tasks>>,
        AsyncValue<List<Tasks>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
