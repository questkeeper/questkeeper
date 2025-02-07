abstract class AnalyticsInterface {
  void identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  });

  void enable();
  void disable();
  void reset();
  bool get isEnabled;
}
