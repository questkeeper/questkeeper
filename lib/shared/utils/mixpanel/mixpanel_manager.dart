// mixpanel_manager.dart
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:questkeeper/shared/utils/mixpanel/mixpanel_stub.dart';

class MixpanelManager implements MixpanelInterface {
  static final MixpanelManager _instance = MixpanelManager._internal();
  static Mixpanel? _mixpanel;

  MixpanelManager._internal();
  static MixpanelManager get instance => _instance;

  // Initialize Mixpanel
  @override
  Future<void> init(String token) async {
    _mixpanel ??= await Mixpanel.init(token,
        trackAutomaticEvents: true, optOutTrackingDefault: false);
  }

  @override
  void track(String eventName, {Map<String, dynamic>? properties}) {
    _mixpanel?.track(eventName, properties: properties);
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    properties.forEach((key, value) {
      _mixpanel?.getPeople().set(key, value);
    });
  }

  @override
  void identify(String userId) {
    _mixpanel?.identify(userId);
  }

  @override
  void reset() {
    _mixpanel?.reset();
  }

  @override
  void setFlushInterval(int interval) {
    _mixpanel?.setFlushBatchSize(interval);
  }

  Mixpanel? get mixpanel => _mixpanel;
  @override
  bool get isInitialized => _mixpanel != null;
}
