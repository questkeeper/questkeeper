import 'package:assigngo_rewrite/shared/utils/onesignal/onesignal_stub.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalMobile implements OneSignalInterface {
  @override
  void initHomeWidget() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("cbc24f01-5a26-4613-82c0-ceb2f8696e4c");
  }

  @override
  void loginExternalUserId(String userId) {
    OneSignal.login(userId);
  }
}
