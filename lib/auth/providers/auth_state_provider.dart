import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/extensions/platform_extensions.dart';
import 'package:questkeeper/shared/utils/mixpanel/mixpanel_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthState {
  final bool isLoading;
  final bool? isAuthenticated;
  final UserResponse? user;
  final Profile? profile;

  AuthState({
    this.isLoading = true,
    this.isAuthenticated,
    this.user,
    this.profile,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserResponse? user,
    Profile? profile,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  static const _authKey = 'was_authenticated';

  AuthStateNotifier(this.ref) : super(AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final wasAuthenticated = prefs.getBool(_authKey) ?? false;
    final cachedProfileJson = prefs.getString("user_profile");

    // If we have a cached profile, use it for truly optimistic UI
    if (wasAuthenticated && cachedProfileJson != null) {
      try {
        final cachedProfile = Profile.fromJson(cachedProfileJson);
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          profile: cachedProfile,
        );
      } catch (e) {
        // If profile parsing fails, still show as authenticated but without profile
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
    }

    // Verify authentication in the background
    _verifyAuth();
  }

  Future<void> _verifyAuth() async {
    try {
      final user = await Supabase.instance.client.auth.getUser();
      final userProfile = await ref.read(profileManagerProvider.future);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString("user_profile", userProfile.toJson());

      // Only update state if something changed to avoid unnecessary rebuilds
      if (state.profile?.user_id != userProfile.user_id ||
          state.user?.user?.id != user.user?.id) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          profile: userProfile,
        );
      }

      if (PlatformExtensions.isMobile) {
        MixpanelManager.instance.identify(user.user!.id);
        MixpanelManager.instance.setUserProperties({
          "email": user.user!.email,
        });
        MixpanelManager.instance.track("User Authenticated");
        _sendDeviceDataToMixpanel();
      }
    } catch (error) {
      // Don't immediately clear auth state on error - only do it if we're sure the session is invalid
      if (error is AuthException || error.toString().contains('JWT')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_authKey, false);
        await prefs.remove("user_profile");

        state = state.copyWith(
          isAuthenticated: false,
          user: null,
          profile: null,
        );
      }
    }
  }

  void _sendDeviceDataToMixpanel() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Map<String, dynamic> deviceInfo;

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = {
        "deviceIdentifier": iosDeviceInfo.identifierForVendor,
        "os": 'iOS ${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}',
        "device": '${iosDeviceInfo.name} ${iosDeviceInfo.model}',
        "appVersion": packageInfo.version,
      };

      MixpanelManager.instance.setUserProperties(deviceInfo);
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = {
        "deviceIdentifier": androidDeviceInfo.id,
        "os":
            'Android ${androidDeviceInfo.version.release} ${androidDeviceInfo.version.sdkInt}',
        "device":
            '${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}',
        "appVersion": packageInfo.version,
      };

      MixpanelManager.instance.setUserProperties(deviceInfo);
    }
  }

// TODO: Call this when I sign out fr fr
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, false);

    state = state.copyWith(
      isAuthenticated: false,
      user: null,
      profile: null,
    );
  }
}
