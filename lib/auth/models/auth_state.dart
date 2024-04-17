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
    required userId,
  }) {
    return SignInState(
      otpSent: otpSent ?? this.otpSent,
      error: error,
    );
  }
}
