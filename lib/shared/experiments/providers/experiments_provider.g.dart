// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExperimentsManager)
const experimentsManagerProvider = ExperimentsManagerProvider._();

final class ExperimentsManagerProvider
    extends $AsyncNotifierProvider<ExperimentsManager, Set<Experiments>> {
  const ExperimentsManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'experimentsManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$experimentsManagerHash();

  @$internal
  @override
  ExperimentsManager create() => ExperimentsManager();
}

String _$experimentsManagerHash() =>
    r'86571e487c3057331790169e17ac8a454210d959';

abstract class _$ExperimentsManager extends $AsyncNotifier<Set<Experiments>> {
  FutureOr<Set<Experiments>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<Set<Experiments>>, Set<Experiments>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Set<Experiments>>, Set<Experiments>>,
        AsyncValue<Set<Experiments>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
