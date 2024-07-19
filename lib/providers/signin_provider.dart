import 'package:flutter/material.dart';
import 'package:geo_j/providers/signin_state.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;

  // final
}
