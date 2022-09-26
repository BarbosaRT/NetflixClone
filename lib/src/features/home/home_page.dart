import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
import 'package:netflix/src/features/login/login_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  late GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double height = 3000.0;
  static const textDuration = Duration(milliseconds: 900);
  static const fadeInDuration = Duration(milliseconds: 700);

  ContentModel content = ContentModel.fromJson(AppConsts.placeholderJson);
  final VideoInterface videoController = GetImpl().getImpl(id: 69);
  final scrollController = ScrollController(initialScrollOffset: 0);

  final ValueNotifier<bool> _alreadyChanged = ValueNotifier(false);

  void callback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    videoController.init(content.trailer, callback: callback);
    videoController.defineThumbnail(content.backdrop);
    super.initState();
    final loginController = context.read<LoginController>();

    if (!loginController.isLogged) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final contentController = Modular.get<ContentController>();

    contentController.addListener(() {
      if (!contentController.loading) {
        content = contentController.getContent('Herois e Outsiders', 0);
        videoController.defineThumbnail(content.backdrop);
        videoController.init(content.trailer);
        setState(() {
          videoController.enableFrame(true);
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 10)).then((value) {
        setState(() {
          videoController.enableFrame(true);
          videoController.play();
        });
      });
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final colorController = Modular.get<ColorController>();

    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    final headline6 = AppFonts().headline6;

    final blackHeadline6 =
        headline6.copyWith(color: Colors.black, fontWeight: FontWeight.w900);

    final homeAppBar =
        HomeAppBar(scrollController: scrollController, height: 500);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        appBar: homeAppBar,
        key: myGlobals.scaffoldKey,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            controller: scrollController,
            child: SmoothScroll(
              scrollSpeed: 90,
              scrollAnimationLength: 150,
              curve: Curves.decelerate,
              controller: scrollController,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Stack(children: [
                  Container(height: height),
                  //
                  // Background Video
                  //
                  ValueListenableBuilder(
                    valueListenable: _alreadyChanged,
                    builder: (context, value, child) {
                      return SingleChildScrollView(
                        child: Stack(
                          children: [
                            videoController.frame(),
                            Container(
                              height: 768,
                              width: 1360,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  //
                  // Video Gradient
                  //
                  Positioned(
                      top: 500,
                      child: Container(
                        height: 400,
                        width: 1360,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withOpacity(0),
                            backgroundColor,
                            backgroundColor,
                          ],
                        )),
                      )),
                  //
                  // Gradient
                  //
                  Container(
                    width: width,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.black.withOpacity(0)
                          ]),
                    ),
                  ),
                  //
                  // Film Logo
                  //
                  SizedBox(
                    width: 1360,
                    height: 600,
                    child: Stack(
                      children: [
                        //
                        // Logo
                        //
                        AnimatedPositioned(
                          top: videoController.isPlaying() ? 300 : 160,
                          left: 55,
                          duration: textDuration,
                          child: AnimatedContainer(
                            duration: textDuration,
                            width: videoController.isPlaying() ? 250 : 400,
                            child: Image.asset(
                              content.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        //
                        // Descrição
                        //
                        AnimatedPositioned(
                          top: videoController.isPlaying() ? 480 : 410,
                          left: 32,
                          duration: textDuration,
                          child: videoController.isPlaying()
                              ? AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText(
                                      content.overview,
                                      textStyle: headline6,
                                      duration: fadeInDuration,
                                    ),
                                  ],
                                  totalRepeatCount: 1,
                                  pause: const Duration(milliseconds: 0),
                                  displayFullTextOnTap: true,
                                  stopPauseOnTap: true,
                                  repeatForever: false,
                                )
                              : SizedBox(
                                  height: 70,
                                  child: Text(
                                    content.overview,
                                    style: headline6,
                                  ),
                                ),
                        ),
                        //
                        // Botao Mais Informações
                        //
                        Positioned(
                          top: 485,
                          left: 30,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Row(children: [
                                HomeButton(
                                  textStyle: blackHeadline6,
                                  overlayColor: Colors.grey.shade300,
                                  buttonColor: Colors.white,
                                  icon: Icons.play_arrow,
                                  text: 'Assistir',
                                ),
                                const SizedBox(width: 10),
                                HomeButton(
                                  textStyle: headline6,
                                  overlayColor:
                                      Colors.grey.shade700.withOpacity(0.3),
                                  buttonColor:
                                      Colors.grey.shade700.withOpacity(0.5),
                                  icon: Icons.info_outline,
                                  iconSize: 25,
                                  spacing: 10,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 25, top: 7, bottom: 7),
                                  text: 'Mais Informações',
                                ),
                              ])),
                        ),
                        //
                        // Classificação Indicativa
                        //
                        Positioned(
                          top: 460,
                          left: 1200,
                          child: Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _alreadyChanged,
                                builder: (context, value, child) {
                                  return videoController.isPlaying()
                                      ? VolumeButton(
                                          onClick: () {
                                            setState(() {});
                                          },
                                          videoController: videoController,
                                          iconOn: Icons.volume_up_outlined,
                                          iconOff: Icons.volume_off_outlined,
                                        )
                                      : VolumeButton(
                                          iconOn: Icons.repeat,
                                          iconOff: Icons.repeat,
                                          onClick: () {
                                            _alreadyChanged.value =
                                                !_alreadyChanged.value;
                                            setState(() {
                                              videoController.enableFrame(true);
                                              videoController.isPlaying()
                                                  ? videoController.pause()
                                                  : videoController.play();
                                            });
                                          },
                                        );
                                },
                              ),
                              Container(
                                  height: 32,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: backgroundColor.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 3,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          videoController.isPlaying(
                                            enable:
                                                !videoController.isPlaying(),
                                          );
                                          _alreadyChanged.value =
                                              !_alreadyChanged.value;
                                        },
                                        child: Image.asset(AppConsts
                                                .classifications[content.age] ??
                                            'images/classifications/L.png'),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contents
                  Positioned(
                    top: 500,
                    child: ListContents(
                      onSeeMore: (String content) {
                        Modular.to
                            .pushNamed('/home/seeMore', arguments: content);
                      },
                    ),
                  ),
                  Positioned(
                    left: width - 13,
                    child: Container(
                      width: 15,
                      height: height,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}

class VolumeButton extends StatefulWidget {
  final VideoInterface? videoController;
  final void Function()? onClick;
  final IconData iconOn;
  final IconData iconOff;
  const VolumeButton(
      {super.key,
      this.videoController,
      this.onClick,
      required this.iconOn,
      required this.iconOff});

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  bool pressed = false;
  bool hover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 2),
      child: MouseRegion(
        opaque: false,
        onExit: (event) {
          setState(() {
            hover = false;
          });
        },
        onHover: (event) {
          setState(() {
            hover = true;
          });
        },
        child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: pressed ? 2 : 1),
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(hover ? 0.1 : 0.0)),
            child: IconButton(
                onPressed: () {
                  if (widget.onClick != null) {
                    widget.onClick!();
                    setState(() {
                      pressed = !pressed;
                    });
                  }
                  if (widget.videoController != null) {
                    widget.onClick?.call();
                    setState(() {
                      pressed = !(widget.videoController!.getVolume() == 0);
                      widget.videoController!.setVolume(pressed ? 0 : 1);
                    });
                  }
                },
                icon: Icon(
                  pressed ? widget.iconOff : widget.iconOn,
                  color: Colors.white,
                  size: pressed ? 16 : 17,
                ))),
      ),
    );
  }
}
