import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/shared/utils/analytics/analytics_stub.dart';

class PosthogAnalytics implements AnalyticsInterface {
  final Posthog _posthog = Posthog();
  bool _isEnabled = true;

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async {
    if (!_isEnabled) return;
    await _posthog.identify(
      userId: userId,
      userProperties: userProperties,
      userPropertiesSetOnce: userPropertiesSetOnce,
    );
  }

  @override
  void enable() async {
    _isEnabled = true;
    debugPrint("Enabling PostHog");
    await _posthog.enable();
  }

  @override
  void disable() async {
    _isEnabled = false;
    debugPrint("Disabling PostHog");
    await _posthog.disable();
  }

  @override
  void reset() async {
    if (!_isEnabled) return;
    debugPrint("Resetting PostHog");
    await _posthog.reset();
  }

  @override
  bool get isEnabled => _isEnabled;
}
