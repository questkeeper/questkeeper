// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$badgesManagerHash() => r'125e7bca8d9e4c6878e3d071257e04883189cc4f';

/// See also [BadgesManager].
@ProviderFor(BadgesManager)
final badgesManagerProvider = AutoDisposeAsyncNotifierProvider<BadgesManager,
    (List<Badge>, List<UserBadge>)>.internal(
  BadgesManager.new,
  name: r'badgesManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$badgesManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BadgesManager
    = AutoDisposeAsyncNotifier<(List<Badge>, List<UserBadge>)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
