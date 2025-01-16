import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

import 'package:questkeeper/shared/extensions/datetime_extensions.dart';

/// Sets the background metadata for the space BGs in Shared Preferences on launch
@Deprecated("This is a notice to remove safeAreaMigration down the line")
void setBackgroundMetadata() async {
  final prefs = SharedPreferencesManager.instance;
  final metadataPath = "assets/images/backgrounds/metadata.json";

  // This is to check if the top stuff has been cached pre-0.8.4+1
  final safeAreaMigration = prefs.getBool("safeAreaMigration") ?? false;

  final backgroundIsSet = prefs.getBool("backgroundsIsSet") ?? false;

  if (backgroundIsSet && safeAreaMigration) return;

  final metadataJson = json.decode(
    await rootBundle.loadString(metadataPath),
  );

  metadataJson["backgroundTypes"].forEach((bg) async {
    for (var i = 0; i < 3; i++) {
      final timeOfDay = TimeOfDayType.values[i];
      await prefs.setString(
        "background_${bg["name"]}_${timeOfDay.toString().split('.').last}",
        bg["colorCodes"][i],
      );

      await prefs.setString(
        "background_${bg["name"]}_top_${timeOfDay.toString().split('.').last}",
        bg["topHalfColorCodes"][i],
      );
    }
  });

  await prefs.setBool("backgroundsIsSet", true);
}
