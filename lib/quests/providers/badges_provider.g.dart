// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BadgesManager)
const badgesManagerProvider = BadgesManagerProvider._();

final class BadgesManagerProvider extends $AsyncNotifierProvider<
    BadgesManager,
    (
      List<Badge>,
      List<UserBadge>,
    )> {
  const BadgesManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'badgesManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$badgesManagerHash();

  @$internal
  @override
  BadgesManager create() => BadgesManager();
}

String _$badgesManagerHash() => r'da5dc8d5dcafd63259df9821a9285f1d7216e8c7';

abstract class _$BadgesManager extends $AsyncNotifier<
    (
      List<Badge>,
      List<UserBadge>,
    )> {
  FutureOr<
      (
        List<Badge>,
        List<UserBadge>,
      )> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        AsyncValue<
            (
              List<Badge>,
              List<UserBadge>,
            )>,
        (
          List<Badge>,
          List<UserBadge>,
        )>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            AsyncValue<
                (
                  List<Badge>,
                  List<UserBadge>,
                )>,
            (
              List<Badge>,
              List<UserBadge>,
            )>,
        AsyncValue<
            (
              List<Badge>,
              List<UserBadge>,
            )>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
