import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
import 'package:netflix/src/features/video/player_impl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final videoController = context.read<PlayerImpl>();
    videoController.init();
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

    final videoController = context.watch<PlayerImpl>();

    final labelLarge = Theme.of(context).textTheme.labelLarge!.copyWith(
        color: Colors.grey.shade200, fontSize: 14, fontFamily: 'Arial');

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    final headline6 = Theme.of(context)
        .textTheme
        .headline6!
        .copyWith(color: Colors.white, fontSize: 17);

    final blackHeadline6 =
        headline6.copyWith(color: Colors.black, fontWeight: FontWeight.w900);

    final buttonLabels = [
      'Inicio',
      'Séries',
      'Filmes',
      'Bombando',
      'Minha lista'
    ];

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
          controller: scrollController,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Stack(children: [
              //
              // Background Video
              //
              SingleChildScrollView(
                child: Column(
                  children: [
                    videoController.frame(),
                  ],
                ),
              ),
              //
              // Film Logo
              //
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 0),
                child: SizedBox(
                  width: 1000,
                  height: 487,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: videoController.isPlaying() ? 350 : 500,
                        child: Image.asset('assets/images/Minions-Logo.png'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                          '''     Lorem Ipsum is simply dummy text of the printing and typesetting 
     Lorem Ipsum has been the industry's standard dummy text ever, 
     when an unknown printer took a galley of type  ''',
                          style: headline6),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
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
                    ],
                  ),
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
            ]),
          ),
        ));
  }
}
