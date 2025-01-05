import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingState {
  final bool hasCreatedSpace;
  final bool hasCreatedCategory;
  final bool hasCreatedTask;
  final bool hasCompletedTask;
  final bool isOnboardingComplete;
  int completedSteps = 0;

  OnboardingState({
    this.hasCreatedSpace = false,
    this.hasCreatedCategory = false,
    this.hasCreatedTask = false,
    this.hasCompletedTask = false,
    this.isOnboardingComplete = false,
    this.completedSteps = 0,
  });

  OnboardingState copyWith({
    bool? hasCreatedSpace,
    bool? hasCreatedCategory,
    bool? hasCreatedTask,
    bool? hasCompletedTask,
    bool? isOnboardingComplete,
    int? completedSteps,
  }) {
    return OnboardingState(
      hasCreatedSpace: hasCreatedSpace ?? this.hasCreatedSpace,
      hasCreatedCategory: hasCreatedCategory ?? this.hasCreatedCategory,
      hasCreatedTask: hasCreatedTask ?? this.hasCreatedTask,
      hasCompletedTask: hasCompletedTask ?? this.hasCompletedTask,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SharedPreferences _prefs;

  OnboardingNotifier(this._prefs) : super(OnboardingState()) {
    refresh();
  }

  void refresh() {
    final completedSteps = _prefs.getStringList('onboarding_completed_steps');
    state = OnboardingState(
      isOnboardingComplete: _prefs.getBool('onboarding_complete') ?? false,
      completedSteps: completedSteps?.length ?? 0,
      hasCreatedSpace: completedSteps?.contains('hasCreatedSpace') ?? false,
      hasCreatedCategory:
          completedSteps?.contains('hasCreatedCategory') ?? false,
      hasCreatedTask: completedSteps?.contains('hasCreatedTask') ?? false,
      hasCompletedTask: completedSteps?.contains('hasCompletedTask') ?? false,
    );
  }

  void markSpaceCreated() {
    state = state.copyWith(
      hasCreatedSpace: true,
    );
    _incrementCompletedSteps("hasCreatedSpace");
  }

  void markCategoryCreated() {
    state = state.copyWith(
      hasCreatedCategory: true,
    );
    _incrementCompletedSteps("hasCreatedCategory");
  }

  void markTaskCreated() {
    state = state.copyWith(
      hasCreatedTask: true,
    );
    _incrementCompletedSteps("hasCreatedTask");
  }

  void markTaskCompleted() {
    state = state.copyWith(
      hasCompletedTask: true,
    );
    _incrementCompletedSteps("hasCompletedTask");
  }

  void _incrementCompletedSteps(String completedKey) {
    final steps = _prefs.getStringList('onboarding_completed_steps') ?? [];
    if (!steps.contains(completedKey)) {
      _prefs.setStringList(
        'onboarding_completed_steps',
        [...steps, completedKey],
      );
    }

    state = state.copyWith(completedSteps: steps.length + 1);

    if (state.completedSteps == 4) {
      state = state.copyWith(isOnboardingComplete: true);

      if (state.hasCreatedSpace &&
          state.hasCreatedCategory &&
          state.hasCreatedTask &&
          state.hasCompletedTask) {
        state = state.copyWith(isOnboardingComplete: true);
        _prefs.setBool('onboarding_complete', true);
      }
    }
  }

  void resetOnboarding() {
    state = OnboardingState();
    _prefs.setBool('onboarding_complete', false);
    _prefs.setStringList('onboarding_completed_steps', []);
  }

  void markAllTasksAsDone() {
    state = state.copyWith(
      isOnboardingComplete: true,
    );

    _prefs.setBool('onboarding_complete', true);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);

  return prefsAsync.when(
    data: (prefs) => OnboardingNotifier(prefs),
    loading: () => throw UnimplementedError(), // Or handle loading state
    error: (error, stack) => throw error, // Or handle error state
  );
});

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
