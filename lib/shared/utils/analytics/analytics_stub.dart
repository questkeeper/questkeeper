abstract class AnalyticsInterface {
  void identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  });

  void trackEvent({
    required String eventName,
    Map<String, dynamic>? properties,
  });

  void trackScreen({
    required String screenName,
    Map<String, dynamic>? properties,
  });

  void trackError({
    required String errorName,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  });

  void enable();
  void disable();
  void reset();
  bool get isEnabled;
}
