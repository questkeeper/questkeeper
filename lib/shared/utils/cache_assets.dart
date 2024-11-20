import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CacheAssetsManager {
  final cacheManager = DefaultCacheManager();
  final supabaseStorageClient = Supabase.instance.client.storage;
  late final SharedPreferences prefs;

  Future<void> fetchAllMetadata() async {
    final backgroundMetadataUrl = supabaseStorageClient
        .from("assets")
        .getPublicUrl("backgrounds/metadata.json");
    prefs = await SharedPreferences.getInstance();

    final List<String> backgroundUrls = [];
    final List<Future<void>> backgroundCacheTasks = [];

    final backgroundMetadata =
        await _fetchMetadataFromUrl(backgroundMetadataUrl);

    for (final background in backgroundMetadata["backgroundTypes"]) {
      for (final timeOfDayType in TimeOfDayType.values) {
        final timeOfDayString = timeOfDayType.toString().split(".").last;
        final String url = supabaseStorageClient.from("assets").getPublicUrl(
            "backgrounds/${background["name"]}/$timeOfDayString.png");
        backgroundUrls.add(url);
        backgroundCacheTasks.add(_cacheImage(url));

        // Store the color codes in local storage
        prefs.setString(
          "background_${background["name"]}_$timeOfDayString",
          background["colorCodes"]
              [timeOfDayType.index % background["colorCodes"].length],
        );
      }
    }

    await Future.wait(backgroundCacheTasks);
  }

  Future<void> _cacheImage(String url) async {
    try {
      CachedNetworkImageProvider(url);
    } catch (e) {
      debugPrint("Error caching image $url: $e");
    }
  }

  Future<Map<String, dynamic>> _fetchMetadataFromUrl(String url) async {
    try {
      final File file = await cacheManager
          .getSingleFile(url, headers: {"Cache-Control": "no-cache"});
      final String content = await file.readAsString();

      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error fetching metadata for $url: $e");
      return {}; // Return an empty map on failure
    }
  }
}
