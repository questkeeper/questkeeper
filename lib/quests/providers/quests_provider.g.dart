// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questsManagerHash() => r'aaf27ed174d0f31d7b5bfad61f73fe257b5a7b63';

/// See also [QuestsManager].
@ProviderFor(QuestsManager)
final questsManagerProvider =
    AutoDisposeAsyncNotifierProvider<QuestsManager, List<UserQuest>>.internal(
  QuestsManager.new,
  name: r'questsManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questsManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuestsManager = AutoDisposeAsyncNotifier<List<UserQuest>>;
String _$completedQuestsManagerHash() =>
    r'481d70b6cd6df385a744c8f23e99c018b0bccc46';

/// See also [CompletedQuestsManager].
@ProviderFor(CompletedQuestsManager)
final completedQuestsManagerProvider = AutoDisposeAsyncNotifierProvider<
    CompletedQuestsManager, List<UserQuest>>.internal(
  CompletedQuestsManager.new,
  name: r'completedQuestsManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedQuestsManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompletedQuestsManager = AutoDisposeAsyncNotifier<List<UserQuest>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
