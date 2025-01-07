import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class OnboardingState {
  final bool hasCreatedSpace;
  final bool hasCreatedCategory;
  final bool hasCreatedTask;
  final bool hasCompletedTask;
  final bool isOnboardingComplete;
  final bool playIsCompletingAnimation;
  int completedSteps = 0;

  OnboardingState({
    this.hasCreatedSpace = false,
    this.hasCreatedCategory = false,
    this.hasCreatedTask = false,
    this.hasCompletedTask = false,
    this.isOnboardingComplete = false,
    this.playIsCompletingAnimation = false,
    this.completedSteps = 0,
  });

  OnboardingState copyWith({
    bool? hasCreatedSpace,
    bool? hasCreatedCategory,
    bool? hasCreatedTask,
    bool? hasCompletedTask,
    bool? isOnboardingComplete,
    bool? playIsCompletingAnimation,
    int? completedSteps,
  }) {
    return OnboardingState(
      hasCreatedSpace: hasCreatedSpace ?? this.hasCreatedSpace,
      hasCreatedCategory: hasCreatedCategory ?? this.hasCreatedCategory,
      hasCreatedTask: hasCreatedTask ?? this.hasCreatedTask,
      hasCompletedTask: hasCompletedTask ?? this.hasCompletedTask,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      playIsCompletingAnimation:
          playIsCompletingAnimation ?? this.playIsCompletingAnimation,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  static final SharedPreferencesManager _prefs =
      SharedPreferencesManager.instance;

  OnboardingNotifier() : super(OnboardingState()) {
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
      playIsCompletingAnimation: false,
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
      state = state.copyWith(playIsCompletingAnimation: true);

      // Set a timer to play the animation
      Future.delayed(const Duration(seconds: 5), () {
        state = state.copyWith(
          isOnboardingComplete: true,
          playIsCompletingAnimation: false,
        );

        if (state.hasCreatedSpace &&
            state.hasCreatedCategory &&
            state.hasCreatedTask &&
            state.hasCompletedTask) {
          _prefs.setBool('onboarding_complete', true);
        }
      });
      return;
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
  return OnboardingNotifier();
});
