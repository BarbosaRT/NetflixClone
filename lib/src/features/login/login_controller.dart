import 'package:flutter/foundation.dart';

class LoginController extends ChangeNotifier {
  bool _isLogged = true;
  bool get isLogged => _isLogged;

  String _email = '';
  String _senha = '';

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
