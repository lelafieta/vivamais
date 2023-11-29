import 'package:flutter/material.dart';

class AuthBiometricController extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void setValue(bool newValue) {
    _value = newValue;
    notifyListeners();
  }
}
