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

  void startSplash(int seconds) {
    waitSplash();
    Future.delayed(Duration(seconds: seconds)).then((value) {
      finishSplash();
    });
  }
}
