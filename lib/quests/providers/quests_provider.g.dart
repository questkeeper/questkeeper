// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuestsManager)
const questsManagerProvider = QuestsManagerProvider._();

final class QuestsManagerProvider
    extends $AsyncNotifierProvider<QuestsManager, List<UserQuest>> {
  const QuestsManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'questsManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$questsManagerHash();

  @$internal
  @override
  QuestsManager create() => QuestsManager();
}

String _$questsManagerHash() => r'aaf27ed174d0f31d7b5bfad61f73fe257b5a7b63';

abstract class _$QuestsManager extends $AsyncNotifier<List<UserQuest>> {
  FutureOr<List<UserQuest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<UserQuest>>, List<UserQuest>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<UserQuest>>, List<UserQuest>>,
        AsyncValue<List<UserQuest>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CompletedQuestsManager)
const completedQuestsManagerProvider = CompletedQuestsManagerProvider._();

final class CompletedQuestsManagerProvider
    extends $AsyncNotifierProvider<CompletedQuestsManager, List<UserQuest>> {
  const CompletedQuestsManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'completedQuestsManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$completedQuestsManagerHash();

  @$internal
  @override
  CompletedQuestsManager create() => CompletedQuestsManager();
}

String _$completedQuestsManagerHash() =>
    r'481d70b6cd6df385a744c8f23e99c018b0bccc46';

abstract class _$CompletedQuestsManager
    extends $AsyncNotifier<List<UserQuest>> {
  FutureOr<List<UserQuest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<UserQuest>>, List<UserQuest>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<UserQuest>>, List<UserQuest>>,
        AsyncValue<List<UserQuest>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
