// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_quests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalQuestManager)
const globalQuestManagerProvider = GlobalQuestManagerProvider._();

final class GlobalQuestManagerProvider
    extends $AsyncNotifierProvider<GlobalQuestManager, GlobalQuest> {
  const GlobalQuestManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'globalQuestManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$globalQuestManagerHash();

  @$internal
  @override
  GlobalQuestManager create() => GlobalQuestManager();
}

String _$globalQuestManagerHash() =>
    r'53fd67b18d9da3401bbaa0896e5f5ec60d5e871e';

abstract class _$GlobalQuestManager extends $AsyncNotifier<GlobalQuest> {
  FutureOr<GlobalQuest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<GlobalQuest>, GlobalQuest>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<GlobalQuest>, GlobalQuest>,
        AsyncValue<GlobalQuest>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserGlobalQuestContributionManager)
const userGlobalQuestContributionManagerProvider =
    UserGlobalQuestContributionManagerProvider._();

final class UserGlobalQuestContributionManagerProvider
    extends $AsyncNotifierProvider<UserGlobalQuestContributionManager,
        UserGlobalQuestContribution> {
  const UserGlobalQuestContributionManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userGlobalQuestContributionManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$userGlobalQuestContributionManagerHash();

  @$internal
  @override
  UserGlobalQuestContributionManager create() =>
      UserGlobalQuestContributionManager();
}

String _$userGlobalQuestContributionManagerHash() =>
    r'0dd240750cafebf79469ee1a8360d1c396092dd1';

abstract class _$UserGlobalQuestContributionManager
    extends $AsyncNotifier<UserGlobalQuestContribution> {
  FutureOr<UserGlobalQuestContribution> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserGlobalQuestContribution>,
        UserGlobalQuestContribution>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserGlobalQuestContribution>,
            UserGlobalQuestContribution>,
        AsyncValue<UserGlobalQuestContribution>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GlobalQuestsHistoryManager)
const globalQuestsHistoryManagerProvider =
    GlobalQuestsHistoryManagerProvider._();

final class GlobalQuestsHistoryManagerProvider extends $AsyncNotifierProvider<
    GlobalQuestsHistoryManager, List<GlobalQuest>> {
  const GlobalQuestsHistoryManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'globalQuestsHistoryManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$globalQuestsHistoryManagerHash();

  @$internal
  @override
  GlobalQuestsHistoryManager create() => GlobalQuestsHistoryManager();
}

String _$globalQuestsHistoryManagerHash() =>
    r'27e61e036e3aee0764464128f906073d0978d3b9';

abstract class _$GlobalQuestsHistoryManager
    extends $AsyncNotifier<List<GlobalQuest>> {
  FutureOr<List<GlobalQuest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<GlobalQuest>>, List<GlobalQuest>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<GlobalQuest>>, List<GlobalQuest>>,
        AsyncValue<List<GlobalQuest>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
