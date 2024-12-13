import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/repositories/profile_repository.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileManager extends _$ProfileManager {
  final ProfileRepository _repository;

  ProfileManager() : _repository = ProfileRepository();

  @override
  FutureOr<Profile> build() async {
    // Try to get cached profile first
    final prefs = await SharedPreferences.getInstance();
    final cachedProfileJson = prefs.getString("user_profile");

    if (cachedProfileJson != null) {
      try {
        return Profile.fromJson(cachedProfileJson);
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

      final profile = Profile.fromMap(response.data);

      // Cache my profile
      if (username == "me") {
        final prefs = await SharedPreferences.getInstance();
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
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updateUsername(username);
      if (!result.success) return result;

      await fetchProfile();

      return const ReturnModel(
          message: "Username updated successfully", success: true);
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
