import 'package:flutter/material.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/repositories/signin_repositories.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;
  SigninProvider({required this.signinRepositories});

  final SigninRepositories signinRepositories;

  Future<void> signin({
    required String phoneNumber,
  }) async {
    _state = _state.copyWith(signinStatus: SigninStatus.submitting);
    notifyListeners();

    try {
      final signinInfo =
          await signinRepositories.signin(phoneNumber: phoneNumber);
      _state = _state.copyWith(
          signinStatus: SigninStatus.success, signinInfo: signinInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
