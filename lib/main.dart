import 'package:netflix/init_desktop.dart'
    if (dart.library.html) 'package:netflix/init_html.dart' as init;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:netflix/src/main_widget.dart';

void main() async {
  // Ensure these two lines are added to main
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();

  init.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
