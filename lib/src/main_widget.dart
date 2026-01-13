import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/core/api/content_controller.dart';
import 'package:oldflix/core/app_consts.dart';
import 'package:oldflix/core/colors/color_controller.dart';
import 'package:oldflix/models/content_model.dart';
import 'package:oldflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:oldflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:oldflix/src/features/home/components/content_list/list_contents.dart';
import 'package:oldflix/src/features/home/components/detail/detail_page.dart';
import 'package:oldflix/src/features/home/components/see_more/see_more_page.dart';
import 'package:oldflix/src/features/home/home_page.dart';
import 'package:oldflix/src/features/login/login_controller.dart';
import 'package:oldflix/src/features/login/login_page.dart';
import 'package:oldflix/src/features/player/player_page.dart';
import 'package:oldflix/src/features/profile/controllers/profile_controller.dart';
import 'package:oldflix/src/features/profile/profile_page.dart';
import 'package:oldflix/src/features/splash/splash_controller.dart';
import 'package:oldflix/src/features/splash/splash_page.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(ProfileController.new);
    i.addSingleton(SplashController.new);
    i.addSingleton(HomeAppBarController.new);
    i.addSingleton(HoverNotification.new);
    i.addSingleton(ColorController.new);
    i.addSingleton(LoginController.new);
    i.addSingleton(ListContentController.new);
    i.addSingleton(ContentController.new);
    i.addSingleton(PlayerNotifier.new);
  }

  @override
  void routes(r) {
    r.child('/login', child: (context) => const LoginPage());
    r.child('/profile', child: (context) => const ProfilePage());
    r.child('/splash', child: (context) => const SplashPage());
    r.child('/video', child: (context) => const PlayerPage());
    r.redirect('/', to: '/login');
    r.child('/home', child: (context) => const HomePage());
    r.child(
      '/home/seeMore',
      child: (context) => SeeMorePage(
        title: r.args.data,
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
    );
    r.child(
      '/home/detail',
      child: (context) {
        // Handle the case where r.args.data might be an ImmutableMap
        ContentModel? content;
        if (r.args.data is ContentModel) {
          content = r.args.data as ContentModel;
        } else if (r.args.data is Map<String, dynamic>) {
          content = ContentModel.fromMap(r.args.data as Map<String, dynamic>);
        } else {
          // Fallback to placeholder content
          content = ContentModel.fromJson(AppConsts.placeholderJson);
        }
        return DetailPage(content: content);
      },
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
    );
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Oldflix',
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
            trackVisibility: WidgetStateProperty.resolveWith((states) => true)),
        primarySwatch: Colors.blue,
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
