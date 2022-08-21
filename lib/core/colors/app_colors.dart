import 'package:flutter/material.dart';

class AppColors {
  Color loginButtonColor;
  Color loginTextFieldColor;
  Color backgroundColor;

  AppColors({
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 1),
    this.loginTextFieldColor = const Color.fromRGBO(51, 51, 51, 1),
    this.loginButtonColor = const Color.fromRGBO(228, 0, 0, 1),
  });
}
