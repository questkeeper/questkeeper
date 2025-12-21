// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widget_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing home widget settings

@ProviderFor(HomeWidgetSettingsManager)
const homeWidgetSettingsManagerProvider = HomeWidgetSettingsManagerProvider._();

/// Provider for managing home widget settings
final class HomeWidgetSettingsManagerProvider
    extends $NotifierProvider<HomeWidgetSettingsManager, HomeWidgetSettings> {
  /// Provider for managing home widget settings
  const HomeWidgetSettingsManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeWidgetSettingsManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetSettingsManagerHash();

  @$internal
  @override
  HomeWidgetSettingsManager create() => HomeWidgetSettingsManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeWidgetSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeWidgetSettings>(value),
    );
  }
}

String _$homeWidgetSettingsManagerHash() =>
    r'6fd41fd55be47ec8dcbe1dc0a9b5d2c0ffd97292';

/// Provider for managing home widget settings

abstract class _$HomeWidgetSettingsManager
    extends $Notifier<HomeWidgetSettings> {
  HomeWidgetSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeWidgetSettings, HomeWidgetSettings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HomeWidgetSettings, HomeWidgetSettings>,
        HomeWidgetSettings,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
