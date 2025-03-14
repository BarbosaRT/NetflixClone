import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';
import 'package:netflix/src/features/home/components/detail/detail_page.dart';
import 'package:netflix/src/features/home/components/see_more/see_more_page.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/login/login_controller.dart';
import 'package:netflix/src/features/login/login_page.dart';
import 'package:netflix/src/features/player/player_page.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:netflix/src/features/profile/profile_page.dart';
import 'package:netflix/src/features/splash/splash_controller.dart';
import 'package:netflix/src/features/splash/splash_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => ProfileController()),
        Bind((i) => SplashController()),
        Bind((i) => HomeAppBarController()),
        Bind((i) => HoverNotification()),
        Bind((i) => ColorController()),
        Bind((i) => LoginController()),
        Bind((i) => ListContentController()),
        Bind((i) => ContentController()),
        Bind((i) => PlayerNotifier()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/login', child: (context, args) => const LoginPage()),
        ChildRoute('/profile', child: (context, args) => const ProfilePage()),
        ChildRoute('/splash', child: (context, args) => const SplashPage()),
        ChildRoute(
          '/video',
          child: (context, args) => const PlayerPage(),
        ),
        RedirectRoute('/', to: '/login'),
        ChildRoute(
          '/home',
          child: (context, args) => const HomePage(),
        ),
        ChildRoute(
          '/home/seeMore',
          child: (context, args) => SeeMorePage(
            title: args.data,
          ),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
              opaque: false,
              transitionBuilder: (context, anim1, anim2, child) {
                const double begin = 0.9;
                const double end = 1;
                final tween = Tween(begin: begin, end: end);
                final offsetAnimation = anim1.drive(tween);

                return FadeTransition(
                  opacity: anim1,
                  child: ScaleTransition(
                    scale: offsetAnimation,
                    child: child,
                  ),
                );
              }),
        ),
        ChildRoute(
          '/home/detail',
          child: (context, args) => DetailPage(
            content: args.data,
          ),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
              opaque: false,
              transitionBuilder: (context, anim1, anim2, child) {
                const double begin = 0.9;
                const double end = 1;
                final tween = Tween(begin: begin, end: end);
                final offsetAnimation = anim1.drive(tween);

                return FadeTransition(
                  opacity: anim1,
                  child: ScaleTransition(
                    scale: offsetAnimation,
                    child: child,
                  ),
                );
              }),
        ),
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
            trackVisibility: WidgetStateProperty.resolveWith((states) => true)),
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
