abstract class MixpanelInterface {
  void init(String token);
  void track(String eventName, {Map<String, dynamic>? properties});
  void setUserProperties(Map<String, dynamic> properties);
  void identify(String userId);
  void reset();
  void setFlushInterval(int interval);
  bool get isInitialized;
}
