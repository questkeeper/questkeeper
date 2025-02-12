import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:flutter/foundation.dart';

/// Sets the background metadata for the space BGs in Shared Preferences on launch
@Deprecated("This is a notice to remove safeAreaMigration down the line")
void setBackgroundMetadata() async {
  final prefs = SharedPreferencesManager.instance;
  final metadataPath = "assets/images/backgrounds/metadata.json";

  try {
    // This is to check if the top stuff has been cached pre-0.8.4+1
    final safeAreaMigration = prefs.getBool("safeAreaMigration") ?? false;
    final backgroundIsSet = prefs.getBool("backgroundsIsSet") ?? false;

    if (backgroundIsSet && safeAreaMigration) return;

    final metadataString = await rootBundle.loadString(metadataPath);
    if (metadataString.isEmpty) {
      debugPrint('Error: Background metadata file is empty');
      return;
    }

    final metadataJson = json.decode(metadataString);
    if (metadataJson == null || !metadataJson.containsKey("backgroundTypes")) {
      debugPrint('Error: Invalid background metadata format');
      return;
    }

    await Future.wait<void>(
      metadataJson["backgroundTypes"].map<Future<void>>((bg) async {
        try {
          for (var i = 0; i < 3; i++) {
            final timeOfDay = TimeOfDayType.values[i];
            final timeOfDayStr = timeOfDay.toString().split('.').last;

            // Set main background color
            await prefs.setString(
              "background_${bg["name"]}_$timeOfDayStr",
              bg["colorCodes"][i],
            );

            // Set top background color
            await prefs.setString(
              "background_${bg["name"]}_top_$timeOfDayStr",
              bg["topHalfColorCodes"][i],
            );
          }
        } catch (e) {
          debugPrint('Error setting background for ${bg["name"]}: $e');
        }
      }).toList(), // Convert Iterable to List
    );

    await prefs.setBool("backgroundsIsSet", true);
    await prefs.setBool("safeAreaMigration", true);
    debugPrint('Background metadata successfully initialized');
  } catch (e) {
    debugPrint('Error setting background metadata: $e');
  }
}
