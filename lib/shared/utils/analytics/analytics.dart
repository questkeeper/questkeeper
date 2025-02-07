import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:questkeeper/shared/utils/analytics/posthog_mobile.dart';
import 'package:questkeeper/shared/utils/analytics/analytics_stub.dart';
import 'package:questkeeper/shared/utils/analytics/analytics_unsupported.dart';

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
}
