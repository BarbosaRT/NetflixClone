import 'package:flutter/foundation.dart';

class LoginController extends ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;

  String _email = '';
  String _senha = '';

  void changeLog(bool newValue) {
    _isLogged = newValue;
    notifyListeners();
  }

  void login() {
    if (!canLog()) {
      return;
    }
    _isLogged = true;
    notifyListeners();
  }

  void changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void changeSenha(String value) {
    _senha = value;
    notifyListeners();
  }

  bool canLog() {
    return _email != '' && _senha.length > 5;
  }
}
