import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:questkeeper/shared/utils/analytics/posthog_mobile.dart';
import 'package:questkeeper/shared/utils/analytics/analytics_stub.dart';
import 'package:questkeeper/shared/utils/analytics/analytics_unsupported.dart';

/// Main analytics interface for the app.
///
/// Provides methods for tracking events, screens, and errors.
/// Use this class as a central point for all analytics tracking.
class Analytics {
  static final AnalyticsInterface instance = _createInstance();

  static AnalyticsInterface _createInstance() {
    if (kIsWeb) {
      return PosthogAnalytics();
    }

    if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
      return PosthogAnalytics();
    }

    return AnalyticsUnsupported();
  }

  /// Track a navigation event
  static void trackNavigation({
    required String from,
    required String to,
    String? method,
  }) {
    instance.trackEvent(
      eventName: 'navigation',
      properties: {
        'from': from,
        'to': to,
        'method': method ?? 'tap',
      },
    );
  }

  /// Track a user action
  static void trackAction({
    required String action,
    String? category,
    Map<String, dynamic>? properties,
  }) {
    final Map<String, dynamic> props = {
      'category': category ?? 'general',
      ...?properties,
    };

    instance.trackEvent(
      eventName: action,
      properties: props,
    );
  }

  /// Track a feature usage
  static void trackFeatureUsage({
    required String feature,
    required String action,
    Map<String, dynamic>? properties,
  }) {
    final Map<String, dynamic> props = {
      'action': action,
      ...?properties,
    };

    instance.trackEvent(
      eventName: 'feature_$feature',
      properties: props,
    );
  }

  /// Track a performance metric
  static void trackPerformance({
    required String operation,
    required int durationMs,
    Map<String, dynamic>? properties,
  }) {
    final Map<String, dynamic> props = {
      'duration_ms': durationMs,
      ...?properties,
    };

    instance.trackEvent(
      eventName: 'perf_$operation',
      properties: props,
    );
  }

  /// Track user engagement
  static void trackEngagement({
    required String type,
    required String itemId,
    String? itemType,
    Map<String, dynamic>? properties,
  }) {
    final Map<String, dynamic> props = {
      'item_id': itemId,
      'item_type': itemType ?? 'unknown',
      ...?properties,
    };

    instance.trackEvent(
      eventName: 'engagement_$type',
      properties: props,
    );
  }
}
