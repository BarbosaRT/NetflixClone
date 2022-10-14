import 'package:flutter/material.dart';

class AppColors {
  Color loginButtonColor;
  Color loginTextFieldColor;
  Color lightBackgroundColor;
  Color containerColor;
  Color likeButtonColor;
  Color darkBackgroundColor;
  Color containerColor2;
  Color containerColor3;

  AppColors({
    this.lightBackgroundColor = const Color.fromRGBO(255, 255, 255, 1),
    this.darkBackgroundColor = const Color.fromRGBO(20, 20, 20, 1),
    this.containerColor = const Color.fromRGBO(25, 25, 25, 1),
    this.likeButtonColor = const Color.fromRGBO(35, 35, 35, 1),
    this.loginTextFieldColor = const Color.fromRGBO(51, 51, 51, 1),
    this.containerColor2 = const Color.fromRGBO(100, 100, 100, 1),
    this.containerColor3 = const Color.fromRGBO(50, 50, 50, 1),
    this.loginButtonColor = const Color.fromRGBO(228, 0, 0, 1),
  });
}
