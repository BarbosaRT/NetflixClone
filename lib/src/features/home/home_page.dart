import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
import 'package:netflix/src/features/home/components/movie_list/list_widget.dart';
import 'package:netflix/src/features/login/login_controller.dart';
import 'package:netflix/src/features/video/player_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final loginController = context.read<LoginController>();
    if (!loginController.isLogged) {
      Navigator.pushReplacementNamed(context, '/login');
    }

    final videoController = context.read<PlayerImpl>();
    videoController.init();
    videoController.defineThumbnail('assets/images/Minions-Background.png');

    videoController.controller.addListener(() {
      if (videoController.controller.value.position ==
          videoController.controller.value.duration) {
        setState(() {
          videoController.enableFrame(false);
        });
      }
    });

    Future.delayed(const Duration(seconds: 2)).then(((value) {
      setState(() {
        videoController.play();
      });
    }));

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    final videoController = context.watch<PlayerImpl>();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final scrollController = ScrollController();

    final videoController = Modular.get<PlayerImpl>();

    final backgroundColor = Colors.grey.shade900;

    final labelLarge = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.grey.shade200,
          fontSize: 14,
          fontFamily: 'Roboto-Medium',
        );

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 17,
            ));

    final blackHeadline6 =
        headline6.copyWith(color: Colors.black, fontWeight: FontWeight.w900);

    final buttonLabels = [
      'Inicio',
      'Séries',
      'Filmes',
      'Bombando',
      'Minha lista'
    ];

    const description =
        '''     O Lorem Ipsum é um texto modelo da indústria tipográfica e de impressão. 
     O Lorem Ipsum tem vindo a ser o texto padrão usado por estas 
     indústrias desde o ano de 1500 quando misturou caracteres...''';

    const textDuration = Duration(milliseconds: 900);
    const fadeInDuration = Duration(milliseconds: 700);

    final homeAppBar = HomeAppBar(
        scrollController: scrollController,
        height: 70,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 55),
            child: SizedBox(
                width: width * 0.07,
                child: Image.asset('assets/images/logo.png')),
          ),
          const SizedBox(
            width: 30,
          ),
          for (var item in buttonLabels)
            TopButton(
                selectedStyle: selectedlabelLarge,
                unselectedStyle: labelLarge,
                name: item),
          SizedBox(
            width: (width - 790),
          ),
          const Icon(
            Icons.search,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          TopButton(
              selectedStyle: selectedlabelLarge,
              unselectedStyle: labelLarge,
              name: 'Infantil'),
          const SizedBox(
            width: 10,
          ),
        ]));

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        appBar: homeAppBar,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              videoController.enableFrame(true);
              videoController.isPlaying()
                  ? videoController.pause()
                  : videoController.play();
            });
          },
          child: Icon(
            videoController.isPlaying() ? Icons.pause : Icons.play_arrow,
          ),
        ),
        body: Scrollbar(
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
                Container(height: 5000),
                //
                // Background Video
                //
                SingleChildScrollView(
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
                ),
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
                        top: videoController.isPlaying() ? 390 : 310,
                        left: 55,
                        duration: textDuration,
                        child: AnimatedContainer(
                          duration: textDuration,
                          width: videoController.isPlaying() ? 350 : 500,
                          child: Image.asset(
                            'assets/images/Minions-Logo-2D.png',
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
                                    description,
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
                                  description,
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
                            const VolumeButton(),
                            Container(
                                height: 32,
                                width: 200,
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
                                    Image.asset('assets/images/L.png'),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 500,
                  child: ListWidget(),
                ),
                Positioned(
                  left: 1348,
                  child: Container(
                    width: 15,
                    height: 2000,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}

class VolumeButton extends StatefulWidget {
  const VolumeButton({super.key});

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  bool pressed = false;

  @override
  void initState() {
    final videoController = Modular.get<PlayerImpl>();
    pressed = !(videoController.getVolume() == 0);
    super.initState();
    setState(() {
      pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoController = Modular.get<PlayerImpl>();

    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 2),
      child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: pressed ? 2 : 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                setState(() {
                  pressed = !(videoController.getVolume() == 0);
                  videoController.setVolume(pressed ? 0 : 1);
                });
              },
              icon: Icon(
                pressed ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                color: Colors.white,
                size: pressed ? 16 : 17,
              ))),
    );
  }
}
