import 'package:questkeeper/shared/utils/analytics/analytics_stub.dart';

class AnalyticsUnsupported implements AnalyticsInterface {
  bool _isEnabled = true;

  @override
  void identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) {
    // No-op implementation
  }

  @override
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? properties,
  }) {
    // No-op implementation
  }

  @override
  void trackScreen({
    required String screenName,
    Map<String, dynamic>? properties,
  }) {
    // No-op implementation
  }

  @override
  void trackError({
    required String errorName,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    // No-op implementation
  }

  @override
  void enable() {
    _isEnabled = true;
  }

  @override
  void disable() {
    _isEnabled = false;
  }

  @override
  void reset() {
    // No-op implementation
  }

  @override
  bool get isEnabled => _isEnabled;
}
