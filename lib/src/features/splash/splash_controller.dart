import 'package:flutter/foundation.dart';

enum SplashState { waiting, finished }

class SplashController extends ChangeNotifier {
  SplashState _splashState = SplashState.waiting;
  SplashState get splashState => _splashState;

  void waitSplash() {
    _splashState = SplashState.waiting;
    notifyListeners();
  }

  void finishSplash() {
    _splashState = SplashState.finished;
    notifyListeners();
  }

  void startSplash(int seconds) async {
    waitSplash();
    await Future.delayed(Duration(seconds: seconds));
    finishSplash();
  }
}
