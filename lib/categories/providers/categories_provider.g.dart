// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoriesManager)
const categoriesManagerProvider = CategoriesManagerProvider._();

final class CategoriesManagerProvider
    extends $AsyncNotifierProvider<CategoriesManager, List<Categories>> {
  const CategoriesManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'categoriesManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$categoriesManagerHash();

  @$internal
  @override
  CategoriesManager create() => CategoriesManager();
}

String _$categoriesManagerHash() => r'185d14094e9b048a1298c401fc622cf84bba1ccb';

abstract class _$CategoriesManager extends $AsyncNotifier<List<Categories>> {
  FutureOr<List<Categories>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Categories>>, List<Categories>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Categories>>, List<Categories>>,
        AsyncValue<List<Categories>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
