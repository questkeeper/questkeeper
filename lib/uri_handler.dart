import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles custom URI schemes.
class QkUriHandler {
  QkUriHandler({required this.supportedSchemes}) {
    _appLinks.uriLinkStream.listen((uri) async {
      debugPrint(uri.toString());
      try {
        await _processUri(uri);
      }
      // on UnsupportedUriScheme {
      //   // URI is unsupported.
      //   // Unsure how to handle exceptions.
      //   rethrow;
      // } on UnknownCustomUri {
      //   // No way to handle the URI.
      //   // Unsure how to handle exceptions.
      //   rethrow;
      // }
      catch (error) {
        SnackbarService.showErrorSnackbar("Unsupported action");
      }
    });
  }

  final _appLinks = AppLinks();
  final List<String> supportedSchemes;

  /// Processes URIs from QK's custom URI scheme.
  ///
  /// If the URI has no way to be handled, [UnknownCustomUri] will be thrown.
  Future<void> _processUri(Uri uri) async {
    debugPrint("Processing URI $uri (host=${uri.host}, path=${uri.path})");

    // Only allow supported schemes.
    if (!supportedSchemes.contains(uri.scheme)) {
      throw UnsupportedUriScheme(uri: uri, supportedSchemes: supportedSchemes);
    }

    switch (uri.host) {
      case "debug":
        if (!kDebugMode) {
          // Can't use print() in production
          throw "$uri is unsupported in non-debug builds";
        }

        final packageInfo = await PackageInfo.fromPlatform();
        debugPrint(
            "Running ${packageInfo.appName} version ${packageInfo.version} (build ${packageInfo.buildNumber})");
        debugPrint("Current time is ${DateTime.now()}. Process ID is $pid.");
        debugPrint("");
        debugPrint("$uri");
        break;

      case "signin":
        debugPrint("Attempting Supabase auth");

        try {
          await Supabase.instance.client.auth.getSessionFromUrl(uri);
        } on AuthException catch (e) {
          if (e.code == "access_denied") {
            closeInAppWebView();
            SnackbarService.showInfoSnackbar("Authorization cancelled.");
          }
        } catch (error) {
          closeInAppWebView();
          SnackbarService.showErrorSnackbar("Something went wrong...");
          rethrow;
        }

        debugPrint("Supabase auth finished without throwing");
        break;

      default:
        throw UnknownCustomUri(uri);
    }
  }
}

/// Thrown when a custom URI has no known way to be handled.
class UnknownCustomUri implements Exception {
  const UnknownCustomUri(this.uri);

  final Uri uri;
}

/// Thrown when a custom URI has a scheme that isn't supported.
class UnsupportedUriScheme implements Exception {
  const UnsupportedUriScheme(
      {required this.uri, required this.supportedSchemes});

  final Uri uri;
  final List<String> supportedSchemes;
}

Future<void> closeInAppBrowser() async {
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await launchUrl(Uri.parse(''), mode: LaunchMode.inAppWebView);
    } catch (e) {
      debugPrint('Failed to close in-app browser: $e');
    }
  }
}
