import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterNativeView.ensureInitialized();
  //useFlutterNativeView: io.Platform.isWindows
  await DartVLC.initialize(useFlutterNativeView: true);
}
