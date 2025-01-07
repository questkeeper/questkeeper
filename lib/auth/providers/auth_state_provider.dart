import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;
  static const _authKey = 'was_authenticated';

  AuthStateNotifier(this.ref) : super(AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
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
    await _verifyAuth(); // TODO: `await` keyword was JUST added, remove it if it starts causing problems...
  }

  Future<void> _verifyAuth() async {
    try {
      final user = await Supabase.instance.client.auth.getUser();
      final userProfile = await ref.read(profileManagerProvider.future);

      await prefs.setBool(_authKey, true);
      await prefs.setString("user_profile", userProfile.toJson());

      try {
        await Posthog().identify(userId: user.user!.id, userPropertiesSetOnce: {
          "date_of_creation": user.user!.createdAt,
        }, userProperties: {
          "email": user.user!.email!,
          "username": user.user!.userMetadata!["display_name"],
        });
      } catch (error) {
        Sentry.captureException(
          error,
          hint: Hint.withMap(
            {
              "location": "auth_state_provider",
              "message": "Posthog auth failed"
            },
          ),
        );
      }

      // Only update state if something changed to avoid unnecessary rebuilds
      if (state.profile?.user_id != userProfile.user_id ||
          state.user?.user?.id != user.user?.id) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          profile: userProfile,
        );
      }
    } catch (error) {
      // Don't immediately clear auth state on error - only do it if we're sure the session is invalid
      if (error is AuthException || error.toString().contains('JWT')) {
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

// This isn't called anywhere, but the signout does remove all of shared prefs
// Removing all shared prefs probs shouldn't be done but it is what it is.
  Future<void> signOut() async {
    await prefs.setBool(_authKey, false);

    state = state.copyWith(
      isAuthenticated: false,
      user: null,
      profile: null,
    );
  }
}
