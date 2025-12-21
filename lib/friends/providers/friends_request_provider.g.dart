// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_request_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendsRequestManager)
const friendsRequestManagerProvider = FriendsRequestManagerProvider._();

final class FriendsRequestManagerProvider extends $AsyncNotifierProvider<
    FriendsRequestManager, Map<String, List<UserSearchResult>>> {
  const FriendsRequestManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'friendsRequestManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$friendsRequestManagerHash();

  @$internal
  @override
  FriendsRequestManager create() => FriendsRequestManager();
}

String _$friendsRequestManagerHash() =>
    r'96c1d123aabdf05368280a1412e0afdac4f47027';

abstract class _$FriendsRequestManager
    extends $AsyncNotifier<Map<String, List<UserSearchResult>>> {
  FutureOr<Map<String, List<UserSearchResult>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        AsyncValue<Map<String, List<UserSearchResult>>>,
        Map<String, List<UserSearchResult>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, List<UserSearchResult>>>,
            Map<String, List<UserSearchResult>>>,
        AsyncValue<Map<String, List<UserSearchResult>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
