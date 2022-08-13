import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
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
    super.initState();
    final videoController = context.read<PlayerImpl>();
    videoController.init();
    videoController.defineThumbnail('assets/images/Minions-Background.png');
    setState(() {});
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

    final labelLarge = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.grey.shade200,
          fontSize: 14,
          fontFamily: 'Roboto-Medium',
        );

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    final headline6 = Theme.of(context).textTheme.headline6!.copyWith(
          color: Colors.white,
          fontSize: 17,
          fontFamily: 'Roboto-Medium',
        );

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
        backgroundColor: Colors.grey.shade900,
        appBar: homeAppBar,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
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
          child: SingleChildScrollView(
            physics: const PageScrollPhysics(),
            controller: scrollController,
            child: Stack(children: [
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
                                  Colors.grey.shade600.withOpacity(0.1),
                              buttonColor: Colors.grey.withOpacity(0.2),
                              icon: Icons.info_outline,
                              iconSize: 25,
                              spacing: 10,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 25, top: 7, bottom: 7),
                              text: 'Mais Informações',
                            ),
                          ])),
                    ),
                    Positioned(
                      top: 465,
                      left: 1255,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.volume_up_outlined)),
                          Container(
                              height: 30,
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900.withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
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
              Positioned(
                left: 1348,
                child: Container(
                  width: 15,
                  height: 2000,
                  color: Colors.white,
                ),
              )
            ]),
          ),
        ));
  }
}
