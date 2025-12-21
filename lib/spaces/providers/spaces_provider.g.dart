// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpacesManager)
const spacesManagerProvider = SpacesManagerProvider._();

final class SpacesManagerProvider
    extends $AsyncNotifierProvider<SpacesManager, List<Spaces>> {
  const SpacesManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'spacesManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$spacesManagerHash();

  @$internal
  @override
  SpacesManager create() => SpacesManager();
}

String _$spacesManagerHash() => r'1fadc5e3bde2f11299172ee14e36db3b0dc961a5';

abstract class _$SpacesManager extends $AsyncNotifier<List<Spaces>> {
  FutureOr<List<Spaces>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Spaces>>, List<Spaces>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Spaces>>, List<Spaces>>,
        AsyncValue<List<Spaces>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
