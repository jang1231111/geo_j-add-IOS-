
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState {
  final SigninStatus signinStatus;
  final SigninInfo signinInfo;
  final CustomError error;

  factory SigninState.initial() {
    return SigninState(
        signinStatus: SigninStatus.initial,
        signinInfo: SigninInfo.initial(),
        error: CustomError());
  }

  SigninState(
      {required this.signinStatus,
      required this.signinInfo,
      required this.error});

  SigninState copyWith({
    SigninStatus? signinStatus,
    SigninInfo? signinInfo,
    CustomError? error,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      signinInfo: signinInfo ?? this.signinInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, signinInfo: $signinInfo, error: $error)';
}
