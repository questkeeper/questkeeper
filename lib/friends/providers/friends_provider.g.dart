// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendsManager)
const friendsManagerProvider = FriendsManagerProvider._();

final class FriendsManagerProvider
    extends $AsyncNotifierProvider<FriendsManager, List<Friend>> {
  const FriendsManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'friendsManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$friendsManagerHash();

  @$internal
  @override
  FriendsManager create() => FriendsManager();
}

String _$friendsManagerHash() => r'da1def8cf6540c023f22602307ec524b66759e69';

abstract class _$FriendsManager extends $AsyncNotifier<List<Friend>> {
  FutureOr<List<Friend>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Friend>>, List<Friend>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Friend>>, List<Friend>>,
        AsyncValue<List<Friend>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
