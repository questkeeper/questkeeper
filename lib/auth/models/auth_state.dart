class SignInState {
  final bool otpSent;
  final String? error;

  SignInState({
    required this.otpSent,
    this.error,
  });

  SignInState copyWith({
    bool? otpSent,
    String? error,
  }) {
    return SignInState(
      otpSent: otpSent ?? this.otpSent,
      error: error,
    );
  }
}
