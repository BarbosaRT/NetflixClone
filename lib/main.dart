import 'package:flutter/foundation.dart';
import 'package:netflix/init_desktop.dart' as init;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:netflix/src/main_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();

  if (!kIsWeb) init.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
