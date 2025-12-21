// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PointsNotificationManager)
const pointsNotificationManagerProvider = PointsNotificationManagerProvider._();

final class PointsNotificationManagerProvider
    extends $NotifierProvider<PointsNotificationManager, Map<String, dynamic>> {
  const PointsNotificationManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pointsNotificationManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pointsNotificationManagerHash();

  @$internal
  @override
  PointsNotificationManager create() => PointsNotificationManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$pointsNotificationManagerHash() =>
    r'4432e23c66c2b914a2b222aee1f73720fc009b0d';

abstract class _$PointsNotificationManager
    extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
        Map<String, dynamic>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
