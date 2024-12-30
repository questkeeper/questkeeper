import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'points_notification_provider.g.dart';

@riverpod
class PointsNotificationManager extends _$PointsNotificationManager {
  Timer? _timer;

  @override
  Map<String, dynamic> build() => {"showBadge": false, "points": 0};

  void showBadgeTemporarily(int points) {
    _timer?.cancel();
    state = {"showBadge": true, "points": points};
    _timer = Timer(const Duration(seconds: 3), () {
      state = {"showBadge": false, "points": 0};
    });
  }
}
