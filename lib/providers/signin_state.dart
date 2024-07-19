import 'package:geo_j/models/custom_error.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState {
  final SigninStatus signinStatus;
  final CustomError customError;

  SigninState({required this.signinStatus, required this.customError});

  factory SigninState.initial() {
    return SigninState(
        signinStatus: SigninStatus.initial, customError: CustomError());
  }

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, customError: $customError)';

  SigninState copyWith({
    SigninStatus? signinStatus,
    CustomError? customError,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      customError: customError ?? this.customError,
    );
  }
}
