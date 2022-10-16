import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/player/components/episode_list.dart';
import 'package:netflix/src/features/player/components/skip_widget.dart';
import 'package:netflix/src/features/player/components/speed_widget.dart';
import 'package:netflix/src/features/player/components/translation_widget.dart';
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
  final ValueNotifier<bool> volumeChanged = ValueNotifier(false);
  Duration _position = const Duration(seconds: 1);
  static const Duration _hover = Duration(milliseconds: 100);

  final ValueNotifier<bool> _playHover = ValueNotifier(false);
  final ValueNotifier<bool> _rewindHover = ValueNotifier(false);
  final ValueNotifier<bool> _forwardHover = ValueNotifier(false);
  final ValueNotifier<bool> _volumeHover = ValueNotifier(false);
  final ValueNotifier<bool> _subtitlesHover = ValueNotifier(false);
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

  //TODO: BUG WHEN SEEKING, dont seek try to pause before
  //TODO: ENABLE FRAME BUGGED
  @override
  void initState() {
    widget.playerModel ??=
        PlayerModel(ContentModel.fromJson(AppConsts.placeholderJson), 0);

    VideoInterface videoController =
        GetImpl().getImpl(id: myGlobals.random.nextInt(69420));
    videoController.init(widget.playerModel!.content.trailer,
        w: 1280, h: 720, callback: callback, positionStream: positionStream);
    videoController.defineThumbnail(widget.playerModel!.content.poster);
    super.initState();
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

    final nextEpisode = episode < episodes.length - 1 ? episode + 1 : 0;
    final nextContent =
        ContentModel.fromMap(episodes[episodes.keys.toList()[nextEpisode]]);

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
    final TextStyle headline = AppFonts().headline6;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;
    final redColor = colorController.currentScheme.loginButtonColor;
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
                bottom: 71,
                left: 20,
                child: SizedBox(
                  width: size.width - 110,
                  child: ValueListenableBuilder(
                    valueListenable: positionChanged,
                    builder: (context, bool value, child) {
                      Duration duration = videoController.getDuration();
                      duration = duration.inSeconds.toInt() <= 0
                          ? const Duration(seconds: 1)
                          : duration;
                      return SliderTheme(
                        data: const SliderThemeData(
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 7)),
                        child: Slider(
                          thumbColor: redColor,
                          activeColor: redColor,
                          inactiveColor: Colors.grey,
                          value: _position.inSeconds.toDouble(),
                          onChanged: (newValue) {
                            videoController.pause();
                            _position = Duration(seconds: newValue.toInt());
                            videoController
                                .seek(Duration(seconds: newValue.toInt()));
                            videoController.play();
                            positionChanged.value = !positionChanged.value;
                          },
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          label: durationFormatter(_position),
                          divisions: duration.inSeconds.toInt(),
                        ),
                      );
                    },
                  ),
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
                left: 10,
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
                    videoController
                        .seek(Duration(seconds: pos - 12 < 10 ? pos + 10 : 0));
                  },
                ),
                left: 160,
              ),
              //
              // Volume
              //
              ValueListenableBuilder(
                  valueListenable: _volumeHover,
                  builder: (context, bool value, child) {
                    return Positioned(
                      bottom: 12,
                      left: 170,
                      child: HoverWidget(
                        useNotification: false,
                        delayOut: const Duration(milliseconds: 200),
                        fadeDuration: Duration.zero,
                        type: HoverType.top,
                        rightPadding: 40,
                        maxWidth: 100,
                        maxHeight: 180,
                        distance: 140,
                        onHover: () {
                          _volumeHover.value = true;
                        },
                        onExit: () {
                          _volumeHover.value = false;
                        },
                        icon: ValueListenableBuilder(
                          valueListenable: volumeChanged,
                          builder: (context, bv, child) {
                            final double v = videoController.getVolume();
                            IconData volumeIcon = Icons.volume_off;
                            if (v > 0.7) {
                              volumeIcon = Icons.volume_up;
                            } else if (v > 0.5) {
                              volumeIcon = Icons.volume_down;
                            } else if (v > 0) {
                              volumeIcon = Icons.volume_mute;
                            }
                            return AnimatedScale(
                              duration: _hover,
                              scale: value ? 1.4 : 1,
                              child: Container(
                                width: 40,
                                height: 40,
                                color: Colors.blue.withOpacity(0.0),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(volumeIcon,
                                      color: Colors.white, size: 40),
                                  onPressed: () {
                                    if (v > 0) {
                                      videoController.setVolume(0);
                                    } else {
                                      videoController.setVolume(1);
                                    }
                                    volumeChanged.value = !volumeChanged.value;
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        child: Container(
                          width: 35,
                          height: 120,
                          alignment: Alignment.topLeft,
                          color: Colors.amber.withOpacity(0),
                          child: Container(
                            width: 30,
                            height: 120,
                            color: backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: ValueListenableBuilder(
                                  valueListenable: volumeChanged,
                                  builder: (context, value, child) {
                                    return SliderTheme(
                                      data: const SliderThemeData(
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 0),
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 7,
                                              elevation: 0,
                                              pressedElevation: 0)),
                                      child: Slider(
                                        value: videoController.getVolume(),
                                        onChanged: (value) {
                                          videoController.setVolume(value);
                                          volumeChanged.value =
                                              !volumeChanged.value;
                                        },
                                        min: 0,
                                        max: 1,
                                        thumbColor: redColor,
                                        activeColor: redColor,
                                        inactiveColor: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
                child: SkipWidget(
                  content: content,
                  videoController: videoController,
                  hover: _hover,
                  nextContent: nextContent,
                  nextEpisode: nextEpisode,
                ),
              ),
              //
              // List Episodes
              //
              Positioned(
                top: size.height - 550,
                right: 0,
                child: EpisodesList(
                  videoController: videoController,
                  hover: _hover,
                  content: content,
                  episode: episode,
                  episodeContent: episodeContent,
                ),
              ),
              //
              // Translations
              //
              Positioned(
                  top: size.height - 569,
                  right: 0,
                  child: const TranslationWidget()),
              //
              // Speed
              //
              Positioned(
                  top: size.height - 240,
                  right: 0,
                  child: SpeedWidget(videoController: videoController)),
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

class PlayerNotifier extends ChangeNotifier {
  int _selectedButton = 0;
  double _selectedSpeed = 0;
  int _selectedCaption = 0;
  int _selectedTranslation = 0;

  void changeSelected(int selected) {
    _selectedButton = selected;
    notifyListeners();
  }

  int getSelected() {
    return _selectedButton;
  }

  void changeSpeed(double selected) {
    _selectedSpeed = selected;
    notifyListeners();
  }

  double getSpeed() {
    return _selectedSpeed;
  }

  void changeTranslation(int translation) {
    _selectedTranslation = translation;
    notifyListeners();
  }

  int getTranslation() {
    return _selectedTranslation;
  }

  void changeCaption(int caption) {
    _selectedCaption = caption;
    notifyListeners();
  }

  int getCaption() {
    return _selectedCaption;
  }
}
