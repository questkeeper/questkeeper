// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtasks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubtasksManager)
const subtasksManagerProvider = SubtasksManagerProvider._();

final class SubtasksManagerProvider
    extends $AsyncNotifierProvider<SubtasksManager, List<Subtask>> {
  const SubtasksManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'subtasksManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$subtasksManagerHash();

  @$internal
  @override
  SubtasksManager create() => SubtasksManager();
}

String _$subtasksManagerHash() => r'c7a91c45ff6dbc1af3c1aa8fc6b3f9c39855a815';

abstract class _$SubtasksManager extends $AsyncNotifier<List<Subtask>> {
  FutureOr<List<Subtask>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Subtask>>, List<Subtask>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Subtask>>, List<Subtask>>,
        AsyncValue<List<Subtask>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
