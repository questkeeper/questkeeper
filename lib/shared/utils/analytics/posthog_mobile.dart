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
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? properties,
  }) async {
    if (!_isEnabled) return;
    debugPrint("Analytics: Tracking event $eventName");

    // Convert Map<String, dynamic> to Map<String, Object>
    final Map<String, Object>? convertedProps = properties != null
        ? Map<String, Object>.fromEntries(
            properties.entries.map((e) => MapEntry(e.key, e.value as Object)))
        : null;

    await _posthog.capture(
      eventName: eventName,
      properties: convertedProps,
    );
  }

  @override
  void trackScreen({
    required String screenName,
    Map<String, dynamic>? properties,
  }) async {
    if (!_isEnabled) return;
    debugPrint("Analytics: Screen view $screenName");

    // Convert Map<String, dynamic> to Map<String, Object>
    final Map<String, Object>? convertedProps = properties != null
        ? Map<String, Object>.fromEntries(
            properties.entries.map((e) => MapEntry(e.key, e.value as Object)))
        : null;

    await _posthog.screen(
      screenName: screenName,
      properties: convertedProps,
    );
  }

  @override
  void trackError({
    required String errorName,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) async {
    if (!_isEnabled) return;
    debugPrint("Analytics: Error $errorName: $error");

    // Create base error properties
    final Map<String, Object> errorProps = {
      'error_message': error.toString(),
      'stack_trace': stackTrace?.toString() ?? 'No stack trace',
    };

    // Add additional properties if provided
    if (properties != null) {
      for (final entry in properties.entries) {
        errorProps[entry.key] = entry.value as Object;
      }
    }

    await _posthog.capture(
      eventName: 'error_$errorName',
      properties: errorProps,
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
