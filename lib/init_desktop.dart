import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterNativeView.ensureInitialized();
  //useFlutterNativeView: io.Platform.isWindows
  MediaKit.ensureInitialized();
}
