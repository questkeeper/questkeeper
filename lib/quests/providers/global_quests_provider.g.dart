// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_quests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalQuestManagerHash() =>
    r'53fd67b18d9da3401bbaa0896e5f5ec60d5e871e';

/// See also [GlobalQuestManager].
@ProviderFor(GlobalQuestManager)
final globalQuestManagerProvider =
    AutoDisposeAsyncNotifierProvider<GlobalQuestManager, GlobalQuest>.internal(
  GlobalQuestManager.new,
  name: r'globalQuestManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalQuestManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalQuestManager = AutoDisposeAsyncNotifier<GlobalQuest>;
String _$userGlobalQuestContributionManagerHash() =>
    r'0dd240750cafebf79469ee1a8360d1c396092dd1';

/// See also [UserGlobalQuestContributionManager].
@ProviderFor(UserGlobalQuestContributionManager)
final userGlobalQuestContributionManagerProvider =
    AutoDisposeAsyncNotifierProvider<UserGlobalQuestContributionManager,
        UserGlobalQuestContribution>.internal(
  UserGlobalQuestContributionManager.new,
  name: r'userGlobalQuestContributionManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userGlobalQuestContributionManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserGlobalQuestContributionManager
    = AutoDisposeAsyncNotifier<UserGlobalQuestContribution>;
String _$globalQuestsHistoryManagerHash() =>
    r'27e61e036e3aee0764464128f906073d0978d3b9';

/// See also [GlobalQuestsHistoryManager].
@ProviderFor(GlobalQuestsHistoryManager)
final globalQuestsHistoryManagerProvider = AutoDisposeAsyncNotifierProvider<
    GlobalQuestsHistoryManager, List<GlobalQuest>>.internal(
  GlobalQuestsHistoryManager.new,
  name: r'globalQuestsHistoryManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalQuestsHistoryManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalQuestsHistoryManager
    = AutoDisposeAsyncNotifier<List<GlobalQuest>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
