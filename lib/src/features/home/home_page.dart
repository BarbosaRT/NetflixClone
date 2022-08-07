import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/appbar/home_appbar.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:netflix/src/features/video/youtube_impl.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final scrollController = ScrollController();

    final videoController = context.watch<YoutubeImpl>();
    _controller.play();

    final labelLarge = Theme.of(context).textTheme.labelLarge!.copyWith(
        color: Colors.grey.shade200, fontSize: 14, fontFamily: 'Arial');

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

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
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
              // VideoApp(),
              // Center(
              //   child: _controller.value.isInitialized
              //       ? AspectRatio(
              //           aspectRatio: _controller.value.aspectRatio,
              //           child: VideoPlayer(_controller),
              //         )
              //       : Container(
              //           width: width,
              //           height: height,
              //           color: Colors.red,
              //         ),
              // ),
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
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0)
                      ]),
                ),
              ),
            ]),
          ),
        ));
  }
}
