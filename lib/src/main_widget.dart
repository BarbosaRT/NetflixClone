import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/login/login_page.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:netflix/src/features/profile/profile_page.dart';
import 'package:netflix/src/features/splash/splash_controller.dart';
import 'package:netflix/src/features/splash/splash_page.dart';
import 'package:netflix/src/features/video/player_impl.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => PlayerImpl()),
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider(create: (_) => SplashController()),
          ChangeNotifierProvider(create: (_) => HomeAppBarController()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Netflix',
          theme: ThemeData(
            scrollbarTheme: ScrollbarThemeData(
                trackVisibility:
                    MaterialStateProperty.resolveWith((states) => true)),
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/login': (context) => const LoginPage(),
            '/profile': (context) => const ProfilePage(),
            '/splash': (context) => const SplashPage(),
            '/': (context) => const HomePage(),
          },
        ));
  }
}
