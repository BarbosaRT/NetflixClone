import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_list_controller.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/login/login_controller.dart';
import 'package:netflix/src/features/login/login_page.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:netflix/src/features/profile/profile_page.dart';
import 'package:netflix/src/features/splash/splash_controller.dart';
import 'package:netflix/src/features/splash/splash_page.dart';
import 'package:netflix/src/features/video/player_impl.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => PlayerImpl()),
        Bind((i) => ProfileController()),
        Bind((i) => SplashController()),
        Bind((i) => HomeAppBarController()),
        Bind((i) => MovieListController()),
        Bind((i) => CurrentMovie(0)),
        Bind((i) => LoginController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/login', child: (context, args) => const LoginPage()),
        ChildRoute('/profile', child: (context, args) => const ProfilePage()),
        ChildRoute('/splash', child: (context, args) => const SplashPage()),
        ChildRoute('/', child: (context, args) => const HomePage()),
      ];
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Netflix',
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
            trackVisibility:
                MaterialStateProperty.resolveWith((states) => true)),
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
