import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/repositories/profile_repository.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileManager extends _$ProfileManager {
  final ProfileRepository _repository;
  final SupabaseClient supabaseClient = Supabase.instance.client;
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;

  ProfileManager() : _repository = ProfileRepository();

  @override
  FutureOr<Profile> build() async {
    // Try to get cached profile first
    final cachedProfileJson = prefs.getString("user_profile");

    if (cachedProfileJson != null) {
      try {
        return Profile.fromJson(jsonDecode(cachedProfileJson));
      } catch (e) {
        return fetchProfile();
      }
    }

    return fetchProfile();
  }

  Future<Profile> fetchProfile({String username = "me"}) async {
    try {
      state = const AsyncValue.loading();
      final ReturnModel response;

      if (username == "me") {
        response = await _repository.getMyProfile();
      } else {
        response = await _repository.getProfile(username);
      }

      var profile = Profile.fromJson(response.data);

      // Cache my profile
      if (username == "me") {
        final isActive = await supabaseClient
            .from("public_user_profiles")
            .select("isActive")
            .eq("user_id", supabaseClient.auth.currentUser!.id)
            .maybeSingle();

        profile = profile.copyWith(
          isActive: isActive == null ? true : isActive["isActive"],
        );

        await prefs.setString("user_profile", response.data.toString());
      }

      return profile;
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
      );
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching profile: $e");
    }
  }

  Future<ReturnModel> updateUsername(String username) async {
    return updateProfile({"username": username});
  }

  Future<ReturnModel> updateProfileVisibility(bool isPublic) async {
    return updateProfile({"isPublic": isPublic});
  }

  Future<ReturnModel> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updateProfile(data);
      prefs.remove("user_profile");
      if (!result.success) return result;

      final updatedProfile = await fetchProfile();
      debugPrint(updatedProfile.toJson().toString());
      state = AsyncValue.data(updatedProfile);

      return const ReturnModel(
          message: "Profile updated successfully", success: true);
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
      );
      state = AsyncValue.error(e, StackTrace.current);

      return ReturnModel(
          message: e.toString(), success: false, error: e.toString());
    }
  }
}
