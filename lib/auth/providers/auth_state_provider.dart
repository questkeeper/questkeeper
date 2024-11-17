import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
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

    // Optimistically show the main UI if user was previously authenticated
    if (wasAuthenticated) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
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
      // Set the user profile
      await prefs.setString("user_profile", userProfile.toJson());

      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        profile: userProfile,
      );
    } catch (error) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, false);

      state = state.copyWith(
        isAuthenticated: false,
        user: null,
        profile: null,
      );
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
