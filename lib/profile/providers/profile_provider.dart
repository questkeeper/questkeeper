import 'dart:async';

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
    return fetchProfile();
  }

  Future<Profile> fetchProfile({String username = "me"}) async {
    try {
      state = const AsyncValue.loading();
      if (username == "me") {
        final profile = (await _repository.getMyProfile()).data;

        return Profile.fromJson(profile);
      } else {
        final profile = (await _repository.getProfile(username)).data;

        return Profile.fromJson(profile);
      }
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
