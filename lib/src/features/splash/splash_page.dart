import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:netflix/src/features/splash/components/icon_painter.dart';
import 'package:netflix/src/features/splash/splash_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<ProfileController>().start();
      Modular.get<SplashController>().startSplash(3);
    });

    var splashNotifier = context.read<SplashController>();
    splashNotifier.addListener(() {
      if (splashNotifier.splashState == SplashState.finished) {
        splashNotifier.waitSplash();
        Modular.to.navigate('/home');
      }
    });
    super.initState();

    final contentController = Modular.get<ContentController>();
    contentController.init();
    contentController.addListener(() {
      if (!contentController.loading) {
        cacheImages();
      }
    });

    final content = ContentModel.fromJson(AppConsts.placeholderJson);
    if (kIsWeb) {
      final videoController = GetImpl().getImpl(id: 69);
      videoController.init(content.trailer);
      videoController.play();
      Future.delayed(const Duration(seconds: 1))
          .then((value) => videoController.pause());
    }
  }

  void cacheImages() {
    final controller = Modular.get<ContentController>();
    for (var i = 0; i < 2; i++) {
      final id = controller.getKey(i);
      for (var j = 0; j < 15; j++) {
        final ContentModel content = controller.getContent(id, j);
        precacheImage(AssetImage(content.poster), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final profileController = context.watch<ProfileController>();
    final colorController = context.watch<ColorController>();

    const stroke = 17;
    const radius = 180.0;
    const ypos = 90;

    final splashIcon = parseSvgPathData(
        'M 0 $ypos A 1 1 90 0 0 $stroke $ypos A 1 1 90 0 1 $radius $ypos A 1 1 90 0 0 0 $ypos');

    final color = colorController.currentScheme.loginButtonColor;
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    return Scaffold(
      body: Stack(children: [
        // Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
        ),
        //
        // Logo
        //
        Padding(
          padding: const EdgeInsets.only(left: 55, top: 21),
          child: SizedBox(
              width: width * 0.07,
              child: Image.asset('assets/images/logo.png')),
        ),
        //
        // Loading
        //
        Padding(
          padding: EdgeInsets.only(left: (width - 130) / 2, top: height * 0.18),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: RotationTransition(
              turns: turnsTween.animate(_animation),
              child: CustomPaint(
                painter: IconPainter(
                  path: splashIcon,
                  color: color,
                ),
                child: Container(
                  height: radius,
                  width: radius,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        //
        // Icon
        //
        Padding(
          padding: EdgeInsets.only(left: (width - 150) / 2, top: height / 6),
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                child: profileController.profiles.isNotEmpty
                    ? SizedBox(
                        width: 75,
                        child: Image.asset(profileController
                            .profiles[profileController.selected].icon),
                      )
                    : Container(),
              )),
        ),
      ]),
    );
  }
}
