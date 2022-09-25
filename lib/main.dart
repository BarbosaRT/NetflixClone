import 'package:netflix/init_desktop.dart'
    if (dart.library.html) 'package:netflix/init_html.dart' as init;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/main_widget.dart';

void main() async {
  init.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
