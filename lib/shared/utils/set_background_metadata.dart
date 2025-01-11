import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

import 'package:questkeeper/shared/extensions/datetime_extensions.dart';

/// Sets the background metadata for the space BGs in Shared Preferences on launch
void setBackgroundMetadata() async {
  final prefs = SharedPreferencesManager.instance;
  final metadataPath = "assets/images/backgrounds/metadata.json";

  if (prefs.getBool("backgroundsIsSet") ?? false) return;

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
    }
  });

  await prefs.setBool("backgroundsIsSet", true);
}
