import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/splash/components/icon_painter.dart';
import 'package:path_drawing/path_drawing.dart';

class PlayerModel {
  final ContentModel content;
  final int episode;

  const PlayerModel(this.content, this.episode);
}

// ignore: must_be_immutable
class PlayerPage extends StatefulWidget {
  PlayerModel? playerModel;
  PlayerPage({super.key, this.playerModel});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final ValueNotifier<bool> positionChanged = ValueNotifier(false);
  Duration _position = const Duration(seconds: 1);
  static const Duration _hover = Duration(milliseconds: 100);

  final ValueNotifier<bool> _playHover = ValueNotifier(false);
  final ValueNotifier<bool> _rewindHover = ValueNotifier(false);
  final ValueNotifier<bool> _forwardHover = ValueNotifier(false);
  final ValueNotifier<bool> _volumeHover = ValueNotifier(false);
  final ValueNotifier<bool> _skipHover = ValueNotifier(false);
  final ValueNotifier<bool> _listHover = ValueNotifier(false);
  final ValueNotifier<bool> _subtitlesHover = ValueNotifier(false);
  final ValueNotifier<bool> _speedHover = ValueNotifier(false);
  final ValueNotifier<bool> _fullHover = ValueNotifier(false);

  // myGlobals.random.nextInt(69420)
  VideoInterface videoController =
      GetImpl().getImpl(id: myGlobals.random.nextInt(69420));
  bool initialized = false;
  void callback() {
    setState(() {});
  }

  void positionStream(Duration position) {
    positionChanged.value = !positionChanged.value;
    _position = position;
  }

  Widget createIcon(Path path, Color color) {
    return CustomPaint(
      painter: IconPainter(
        path: path,
        color: color,
      ),
      child: Container(
        height: 40,
        width: 40,
        color: Colors.transparent,
      ),
    );
  }

  @override
  void initState() {
    widget.playerModel ??=
        PlayerModel(ContentModel.fromJson(AppConsts.placeholderJson), 0);
    VideoInterface videoController =
        GetImpl().getImpl(id: myGlobals.random.nextInt(69420));
    super.initState();

    videoController.init(widget.playerModel!.content.trailer,
        w: 1280, h: 720, callback: callback, positionStream: positionStream);
    videoController.defineThumbnail(widget.playerModel!.content.poster);
  }

  String durationFormatter(Duration duration) {
    String d = duration.toString().split('.')[0];
    if (duration.inHours <= 0) {
      d = d.replaceFirst('0:', '');
    }
    return d;
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  Widget buttonCreator(
      {required ValueNotifier<bool> listenable,
      required Widget icon,
      required int left,
      double? addBottom}) {
    final double a = addBottom ?? 0.0;
    return ValueListenableBuilder(
        valueListenable: listenable,
        builder: (context, bool value, child) {
          return AnimatedPositioned(
            duration: _hover,
            bottom: (value ? 14 : 10) + a,
            left: left.toDouble(),
            child: HoverWidget(
              useNotification: false,
              delayOut: Duration.zero,
              fadeDuration: Duration.zero,
              type: HoverType.top,
              rightPadding: 50,
              maxWidth: 50,
              maxHeight: 50,
              distance: 0,
              detectChildArea: false,
              onHover: () {
                listenable.value = true;
              },
              onExit: () {
                listenable.value = false;
              },
              icon: AnimatedScale(
                  scale: value ? 1.4 : 1, duration: _hover, child: icon),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final episode = widget.playerModel!.episode;
    final episodes = widget.playerModel!.content.episodes!;
    final episodeContent =
        ContentModel.fromMap(episodes[episodes.keys.toList()[episode]]);
    if (!initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          initialized = true;
          videoController.init(episodeContent.trailer,
              w: size.width,
              h: size.height,
              callback: callback,
              positionStream: positionStream);

          setState(() {
            videoController.defineThumbnail(widget.playerModel!.content.poster);
            videoController.enableFrame(true);
          });
        });
      });
    }
    final d = videoController.getDuration();
    final listIcon = parseSvgPathData(
        'M8 5H22V13H24V5C24 3.89543 23.1046 3 22 3H8V5ZM18 9H4V7H18C19.1046 7 20 7.89543 20 9V17H18V9ZM0 13C0 11.8954 0.895431 11 2 11H14C15.1046 11 16 11.8954 16 13V19C16 20.1046 15.1046 21 14 21H2C0.895431 21 0 20.1046 0 19V13ZM14 19V13H2V19H14Z');
    final headline = AppFonts().headline6;
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;
    final content = widget.playerModel!.content;

    return Scaffold(
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Container(
                  width: size.width,
                  height: size.height,
                  color: backgroundColor),
              SizedBox(
                width: size.width,
                height: size.height,
                child: videoController.frame(),
              ),
              //
              // Arrow Back
              //
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/home');
                    videoController.stop();
                  },
                ),
              ),
              //
              // Flag
              //
              Positioned(
                top: 10,
                left: size.width - 60,
                child: IconButton(
                  icon: const Icon(Icons.flag, color: Colors.white, size: 40),
                  onPressed: () {
                    setState(() {
                      videoController.enableFrame(true);
                      initialized = false;
                    });
                  },
                ),
              ),
              //
              // Play
              //
              buttonCreator(
                  listenable: _playHover,
                  icon: IconButton(
                    icon: Icon(
                        videoController.isPlaying()
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 40),
                    onPressed: () {
                      setState(() {
                        videoController.enableFrame(true);
                        videoController.isPlaying()
                            ? videoController.pause()
                            : videoController.play();
                      });
                    },
                  ),
                  left: 10),
              //
              // Duration
              //
              Positioned(
                top: size.height - 87,
                right: 40,
                child: ValueListenableBuilder(
                    valueListenable: positionChanged,
                    builder: (context, bool value, child) {
                      return Text(
                        durationFormatter(d - _position),
                        style: headline,
                      );
                    }),
              ),
              //
              // Slider
              //
              Positioned(
                top: size.height - 100,
                left: 5,
                child: SizedBox(
                  width: size.width - 80,
                  child: ValueListenableBuilder(
                    valueListenable: positionChanged,
                    builder: (context, bool value, child) {
                      return Slider(
                        thumbColor: Colors.red,
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey,
                        value: _position.inSeconds.toDouble(),
                        onChanged: (newValue) {
                          setState(() {
                            _position = Duration(seconds: newValue.toInt());
                            videoController
                                .seek(Duration(seconds: newValue.toInt()));
                          });
                        },
                        min: 0,
                        max: videoController.getDuration().inSeconds.toDouble(),
                        label: durationFormatter(_position),
                        divisions:
                            videoController.getDuration().inSeconds.toInt(),
                      );
                    },
                  ),
                ),
              ),
              //
              // Rewind
              //
              buttonCreator(
                  listenable: _rewindHover,
                  icon: IconButton(
                    icon: const Icon(Icons.fast_rewind,
                        color: Colors.white, size: 40),
                    onPressed: () {
                      final pos = videoController.getPosition().inSeconds;
                      videoController
                          .seek(Duration(seconds: pos > 10 ? pos - 10 : 0));
                    },
                  ),
                  left: 85),
              //
              // Forward
              //
              buttonCreator(
                  listenable: _forwardHover,
                  icon: IconButton(
                    icon: const Icon(Icons.fast_forward,
                        color: Colors.white, size: 40),
                    onPressed: () {
                      final pos = videoController.getPosition().inSeconds;
                      videoController.seek(
                          Duration(seconds: pos - 12 < 10 ? pos + 10 : 0));
                    },
                  ),
                  left: 160),
              //
              // Volume
              //
              Positioned(
                top: size.height - 60,
                left: 240,
                child: IconButton(
                  icon: const Icon(Icons.volume_up,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    videoController.setVolume(1);
                  },
                ),
              ),
              //
              // Title
              //
              Positioned(
                  top: size.height - 45,
                  left: size.width / 2 -
                      AppConsts()
                              .getTextSize(
                                  '${content.title} E${episode + 1} ${episodeContent.title}',
                                  headline)
                              .width /
                          2 -
                      20,
                  child: Text(
                    '${content.title} E${episode + 1} ${episodeContent.title}',
                    style: headline,
                  )),
              //
              // Skip
              //
              Positioned(
                top: size.height - 320,
                right: 70,
                child: HoverWidget(
                  useNotification: false,
                  delayOut: Duration.zero,
                  fadeDuration: Duration.zero,
                  type: HoverType.top,
                  rightPadding: 300,
                  maxWidth: 550,
                  maxHeight: 500,
                  distance: 260,
                  detectChildArea: false,
                  icon: GestureDetector(
                    onTap: () {
                      videoController.stop();
                      Modular.to.popAndPushNamed('/video',
                          arguments: PlayerModel(content,
                              episode < episodes.length - 1 ? episode + 1 : 0));
                    },
                    child: const Icon(Icons.skip_next,
                        color: Colors.white, size: 50),
                  ),
                  child:
                      Container(width: 550, height: 250, color: Colors.green),
                ),
              ),
              //
              // List Episodes
              //
              Positioned(
                top: size.height - 470,
                right: 0,
                child: HoverWidget(
                  useNotification: false,
                  delayOut: Duration.zero,
                  fadeDuration: Duration.zero,
                  type: HoverType.top,
                  rightPadding: 280,
                  maxWidth: 600,
                  maxHeight: 900,
                  distance: 425,
                  detectChildArea: false,
                  icon: GestureDetector(
                    onTap: () {
                      videoController.stop();
                      Modular.to.popAndPushNamed('/video',
                          arguments: PlayerModel(content,
                              episode < episodes.length - 1 ? episode + 1 : 0));
                    },
                    child: Transform.scale(
                        scale: 1.5, child: createIcon(listIcon, Colors.white)),
                  ),
                  child: Container(width: 600, height: 400, color: Colors.blue),
                ),
              ),
              //
              // Translations
              //
              Positioned(
                top: size.height - 559,
                right: 0,
                child: HoverWidget(
                  useNotification: false,
                  delayOut: Duration.zero,
                  fadeDuration: Duration.zero,
                  type: HoverType.top,
                  rightPadding: 220,
                  maxWidth: 450,
                  maxHeight: 600,
                  distance: 500,
                  detectChildArea: false,
                  icon: GestureDetector(
                    onTap: () {
                      videoController.stop();
                      Modular.to.popAndPushNamed('/video',
                          arguments: PlayerModel(content,
                              episode < episodes.length - 1 ? episode + 1 : 0));
                    },
                    child: const Icon(Icons.subtitles,
                        color: Colors.white, size: 43),
                  ),
                  child:
                      Container(width: 450, height: 490, color: Colors.purple),
                ),
              ),
              //
              // Speed
              //
              Positioned(
                top: size.height - 220,
                right: 0,
                child: HoverWidget(
                  useNotification: false,
                  delayOut: Duration.zero,
                  fadeDuration: Duration.zero,
                  type: HoverType.top,
                  rightPadding: 150,
                  maxWidth: 600,
                  maxHeight: 300,
                  distance: 160,
                  detectChildArea: false,
                  icon: GestureDetector(
                    onTap: () {
                      videoController.stop();
                      Modular.to.popAndPushNamed('/video',
                          arguments: PlayerModel(content,
                              episode < episodes.length - 1 ? episode + 1 : 0));
                    },
                    child:
                        const Icon(Icons.speed, color: Colors.white, size: 45),
                  ),
                  child: Container(width: 600, height: 150, color: Colors.grey),
                ),
              ),
              //
              // FullScreen
              //
              buttonCreator(
                  listenable: _fullHover,
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 50,
                  ),
                  addBottom: 2.0,
                  left: (size.width - 85).toInt()),
            ],
          )),
    );
  }
}
