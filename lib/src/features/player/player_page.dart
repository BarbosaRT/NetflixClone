import 'dart:async';
import 'dart:math' as math;
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/player/components/episode_list.dart';
import 'package:netflix/src/features/player/components/skip_widget.dart';
import 'package:netflix/src/features/player/components/speed_widget.dart';
import 'package:netflix/src/features/player/components/translation_widget.dart';
import 'package:netflix/src/features/splash/components/icon_painter.dart';
import 'package:path_drawing/path_drawing.dart';

class PlayerModel {
  final ContentModel content;
  final int episode;

  const PlayerModel(this.content, this.episode);
}

// ignore: must_be_immutable
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with TickerProviderStateMixin, FullScreenListener {
  final ValueNotifier<bool> positionChanged = ValueNotifier(false);
  final ValueNotifier<bool> volumeChanged = ValueNotifier(false);
  Duration _position = const Duration(seconds: 1);
  static const Duration _hoverOff = Duration(seconds: 4);
  static const Duration _delay = Duration(seconds: 2);
  static const Duration _ageDelay = Duration(seconds: 5);
  static const Duration _hover = Duration(milliseconds: 100);
  static const Duration _ageAnimation = Duration(milliseconds: 200);
  static const Duration _ageDuration = Duration(seconds: 3);

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final ValueNotifier<bool> _playHover = ValueNotifier(false);
  final ValueNotifier<bool> _rewindHover = ValueNotifier(false);
  final ValueNotifier<bool> _forwardHover = ValueNotifier(false);
  final ValueNotifier<bool> _volumeHover = ValueNotifier(false);
  final ValueNotifier<bool> _fullHover = ValueNotifier(false);
  bool hover = true;
  bool isFullScreen = false;
  Timer timer = Timer(_hoverOff, () {});
  Timer ageTimer = Timer(_hoverOff, () {});
  VideoInterface videoController =
      GetImpl().getImpl(id: myGlobals.random.nextInt(69420));

  static const stroke = 17;
  static const radius = 180.0;
  static const ypos = 90;

  final splashIcon = parseSvgPathData(
      'M 0 $ypos A 1 1 90 0 0 $stroke $ypos A 1 1 90 0 1 $radius $ypos A 1 1 90 0 0 0 $ypos');

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  late AnimationController _nextController;

  bool initialized = false;
  bool loaded = false;

  bool animationStart = true;
  bool animationEnd = false;
  bool played = false;

  bool almostFinished = false;
  bool finishDetected = false;

  bool finished = false;
  bool finishControllerStarted = false;
  void callback() {
    if (mounted) {
      setState(() {});
    }
  }

  void positionStream(Duration position) {
    positionChanged.value = !positionChanged.value;
    _position = position;

    var playerNotifier = Modular.get<PlayerNotifier>();
    PlayerModel playerModel = playerNotifier.playerModel;
    final episode = playerModel.episode;
    final episodes = playerModel.content.episodes!;
    final episodeContent =
        ContentModel.fromMap(episodes[episodes.keys.toList()[episode]]);
    final creditsTime = episodeContent.creditsTime ??
        30; // Default to 30 seconds if not specified

    if (!finished &&
        !finishControllerStarted &&
        position >=
            Duration(
                milliseconds:
                    videoController.getDuration().inMilliseconds - 500) &&
        videoController.getDuration().inSeconds > 10) {
      finishControllerStarted = true;

      // Stop and dispose existing controller before creating new one
      if (_nextController.isAnimating) {
        _nextController.stop();
      }
      _nextController.dispose();
      _nextController = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,
      )..repeat(reverse: false);

      if (mounted) {
        setState(() {
          finished = true;
          hover = false;
        });
      }
    }

    if (!finishDetected &&
        position >=
            Duration(
              seconds: videoController.getDuration().inSeconds - creditsTime,
            ) &&
        videoController.getDuration().inSeconds > creditsTime) {
      finishDetected = true;

      // Stop and dispose existing controller before creating new one
      if (_nextController.isAnimating) {
        _nextController.stop();
      }
      _nextController.dispose();
      _nextController = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,
      )..repeat(reverse: false);
      if (mounted) {
        setState(() {
          almostFinished = true;
          hover = false;
        });
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          if (!videoController.isPlaying()) {
            videoController.play();
          }
        });
      }
    }
  }

  @override
  void initState() {
    var playerNotifier = Modular.get<PlayerNotifier>();
    PlayerModel playerModel = playerNotifier.playerModel;

    // Add fullscreen listener
    FullScreen.addListener(this);
    isFullScreen = FullScreen.isFullScreen;

    _nextController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: false);
    loaded = false;
    finishDetected = false;
    finishControllerStarted = false;

    // Dispose the old controller before creating a new one
    videoController.dispose();
    videoController = GetImpl().getImpl(id: myGlobals.random.nextInt(69420));
    videoController.init(playerModel.content.trailer,
        w: 1280, h: 720, callback: callback, positionStream: positionStream);
    videoController.defineThumbnail(
        playerModel.content.poster, playerModel.content.isOnline);

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
    // Cancel timers first
    timer.cancel();
    ageTimer.cancel();

    // Dispose animation controllers safely
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();

    if (_nextController.isAnimating) {
      _nextController.stop();
    }
    _nextController.dispose();

    // Dispose video controller
    videoController.dispose();

    // Remove listeners
    FullScreen.removeListener(this);

    // Call super.dispose() last
    super.dispose();
  }

  @override
  void onFullScreenChanged(bool enabled, SystemUiMode? systemUiMode) {
    setState(() {
      isFullScreen = enabled;
    });
  }

  void ageTimerReset() {
    ageTimer.cancel();
    ageTimer = Timer(_ageDelay, () {
      if (mounted) {
        setState(() {
          animationEnd = true;
          animationStart = false;
          played = true;
        });
      }
      Future.delayed(_ageDuration).then((value) {
        if (mounted) {
          setState(() {
            animationEnd = false;
            animationStart = true;
          });
        }
      });
    });
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

    var playerNotifier = Modular.get<PlayerNotifier>();
    PlayerModel playerModel = playerNotifier.playerModel;

    final episode = playerModel.episode;
    final episodes = playerModel.content.episodes!;
    final episodeContent =
        ContentModel.fromMap(episodes[episodes.keys.toList()[episode]]);
    final nextEpisode = episode < episodes.length - 1 ? episode + 1 : 0;
    final nextContent =
        ContentModel.fromMap(episodes[episodes.keys.toList()[nextEpisode]]);

    final nextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_nextController);

    if (!initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialized = true;
        Future.delayed(_delay).then((value) {
          videoController.init(episodeContent.trailer,
              w: size.width,
              h: size.height,
              callback: callback,
              positionStream: positionStream);

          videoController.defineThumbnail(
              playerModel.content.poster, playerModel.content.isOnline);
          videoController.enableFrame(true);
          Future.delayed(const Duration(milliseconds: 300)).then((value) {
            videoController.play();
            videoController.setVolume(0);
          });
          Future.delayed(const Duration(milliseconds: 600)).then(
            (value) {
              videoController.setVolume(1);
              if (mounted) {
                setState(() {
                  played = false;
                });
              }
              ageTimerReset();
            },
          );
        });
      });
    }

    if (!loaded) {
      Future.delayed(_delay).then((value) {
        if (mounted) {
          setState(() {
            loaded = true;
          });
        }
      });
    }
    final d = videoController.getDuration();
    final TextStyle headline = AppFonts().headline6;
    final TextStyle headline2 = AppFonts().headline4;
    final TextStyle headline3 = AppFonts().headline4.copyWith(fontSize: 20);
    final TextStyle headline4 = AppFonts().headline6.copyWith(fontSize: 18);

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;
    final redColor = colorController.currentScheme.loginButtonColor;
    final content = playerModel.content;
    final color = colorController.currentScheme.loginButtonColor;

    final headline6 = AppFonts().headline8;

    final blackHeadline6 =
        headline6.copyWith(color: Colors.black, fontWeight: FontWeight.w900);

    final arrowBack = IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
      onPressed: () {
        Modular.to.pushReplacementNamed('/home');
        videoController.stop();
      },
    );

    Widget slider = SizedBox(
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
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
            child: Slider(
              thumbColor: redColor,
              activeColor: redColor,
              inactiveColor: Colors.grey,
              value: _position.inSeconds.toDouble(),
              onChanged: (newValue) {
                _position = Duration(seconds: newValue.toInt());

                videoController.pause();
                videoController.seek(Duration(seconds: newValue.toInt()));
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
    );

    if (kIsWeb) {
      //
      slider = SizedBox(
        width: size.width - 110,
        child: videoController.slider(
          const EdgeInsets.symmetric(horizontal: 6),
        ),
      );
    }

    final almostFinishedPage = SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: videoController.frame(),
          ),
          Positioned(top: 10, left: 10, child: arrowBack),
          Positioned(
            bottom: 40,
            right: 250,
            child: SizedBox(
              width: 215,
              child: HomeButton(
                textStyle: headline6,
                overlayColor: Colors.grey.shade700.withValues(alpha: 0.7),
                buttonColor: Colors.grey.shade700.withValues(alpha: 0.9),
                icon: Icons.info_outline,
                iconSize: 25,
                spacing: 10,
                padding: const EdgeInsets.only(
                    left: 20, right: 25, top: 7, bottom: 7),
                text: 'Assista aos créditos',
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      almostFinished = false;
                    });
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: SizedBox(
              width: 205,
              child: hover
                  ? HomeButton(
                      textStyle: blackHeadline6,
                      overlayColor: Colors.grey.shade300.withValues(alpha: 0.5),
                      buttonColor: Colors.white,
                      icon: Icons.play_arrow,
                      text: 'Próximo Episodio',
                      padding: const EdgeInsets.only(left: 5, right: 0),
                      onPressed: () {
                        videoController.stop();
                        var playerNotifier = Modular.get<PlayerNotifier>();
                        playerNotifier.playerModel =
                            PlayerModel(content, nextEpisode);
                        Modular.to.popAndPushNamed('/video');
                      },
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        width: 212,
                        height: 40,
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: nextAnimation,
                              builder: (context, child) {
                                if (nextAnimation.value >= 0.99) {
                                  // Use post-frame callback to avoid setState during build
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    videoController.stop();
                                    var playerNotifier =
                                        Modular.get<PlayerNotifier>();
                                    playerNotifier.playerModel =
                                        PlayerModel(content, nextEpisode);
                                    Modular.to.popAndPushNamed('/video');
                                  });
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey.shade300
                                        .withValues(alpha: 0.7),
                                    color: Colors.white,
                                    minHeight: 40,
                                    value: nextAnimation.value,
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Próximo Episodio',
                                  style: blackHeadline6,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          MouseRegion(
            opaque: false,
            onHover: (event) {
              if (mounted) {
                setState(() {
                  hover = true;
                });
              }
            },
            child: SizedBox(width: size.width, height: size.height),
          ),
        ],
      ),
    );

    final loadedPage = KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: (value) async {
        if (value is KeyDownEvent) {
          if (value.logicalKey == LogicalKeyboardKey.space) {
            videoController.isPlaying()
                ? videoController.pause()
                : videoController.play();
          } else if (value.logicalKey == LogicalKeyboardKey.f11 && !kIsWeb) {
            FullScreen.setFullScreen(!isFullScreen);
          }
        }
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            //
            // Video
            //
            SizedBox(
              width: size.width,
              height: size.height,
              child: videoController.frame(),
            ),
            //
            // Video Gradient
            //
            hover
                ? Container()
                : Positioned(
                    top: size.height - 90,
                    child: Container(
                      height: 90,
                      width: size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withAlpha(0),
                            backgroundColor.withAlpha(100),
                          ],
                        ),
                      ),
                    ),
                  ),
            //
            // Classificão Indicativa
            //
            Positioned(
              top: 60,
              left: 60,
              child: SizedBox(
                width: 230,
                height: 50,
                child: Stack(
                  alignment:
                      animationEnd ? Alignment.bottomLeft : Alignment.topLeft,
                  children: [
                    AnimatedContainer(
                      duration: _ageAnimation,
                      width: 230,
                      height: animationEnd ? 50 : 0,
                      color: backgroundColor.withValues(
                          alpha: animationEnd ? 0.22 : 0.0),
                    ),
                    Row(
                      crossAxisAlignment: animationEnd
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: _ageAnimation,
                          height: animationStart ? 0 : 50,
                          width: 5,
                          color: color,
                        ),
                        AnimatedContainer(
                          duration: _ageAnimation,
                          width: 150,
                          height: animationStart ? 30 : 50,
                          alignment: Alignment.center,
                          child: AnimatedOpacity(
                            duration: _ageAnimation,
                            opacity: animationStart ? 0 : 1,
                            child: Text(
                              'Classificação: ',
                              style: headline4,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: _hover,
                          height: animationStart ? 30 : 50,
                          child: AnimatedOpacity(
                            duration: _hover,
                            opacity: animationStart ? 0 : 1,
                            child: Image.asset(
                              AppConsts.classifications[episodeContent.age] ??
                                  'assets/images/classifications/L.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //
            // Arrow Back
            //
            hover
                ? Container()
                : Positioned(top: 10, left: 10, child: arrowBack),
            //
            // Flag
            //
            hover
                ? Container()
                : Positioned(
                    top: 10,
                    left: size.width - 60,
                    child: IconButton(
                      icon:
                          const Icon(Icons.flag, color: Colors.white, size: 40),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            played = false;
                          });
                        }
                      },
                    ),
                  ),
            //
            // Duration
            //
            hover || almostFinished
                ? Container()
                : Positioned(
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
            hover || almostFinished
                ? Container()
                : Positioned(bottom: 71, left: 20, child: slider),
            //
            // Play
            //
            hover || almostFinished
                ? Container()
                : buttonCreator(
                    listenable: _playHover,
                    icon: IconButton(
                      icon: Icon(
                          videoController.isPlaying()
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            videoController.enableFrame(true);
                            videoController.isPlaying()
                                ? videoController.pause()
                                : videoController.play();
                          });
                        }
                      },
                    ),
                    left: 10,
                  ),
            //
            // Rewind
            //
            hover || almostFinished
                ? Container()
                : buttonCreator(
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
            hover || almostFinished
                ? Container()
                : buttonCreator(
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
                    left: 160,
                  ),
            //
            // Volume
            //
            hover || almostFinished
                ? Container()
                : ValueListenableBuilder(
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
                                  color: Colors.blue.withValues(alpha: 0.0),
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
                                      volumeChanged.value =
                                          !volumeChanged.value;
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
                            color: Colors.amber.withValues(alpha: 0),
                            child: Container(
                              width: 30,
                              height: 120,
                              color: backgroundColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: ValueListenableBuilder(
                                    valueListenable: volumeChanged,
                                    builder: (context, value, child) {
                                      return SliderTheme(
                                        data: const SliderThemeData(
                                            overlayShape:
                                                RoundSliderOverlayShape(
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
            hover || almostFinished
                ? Container()
                : Positioned(
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
            hover || almostFinished
                ? Container()
                : Positioned(
                    top: size.height - 321,
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
            hover || almostFinished
                ? Container()
                : Positioned(
                    top: size.height - 565,
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
            hover || almostFinished
                ? Container()
                : Positioned(
                    top: size.height - 569,
                    right: 0,
                    child: const TranslationWidget()),
            //
            // Speed
            //
            hover || almostFinished
                ? Container()
                : Positioned(
                    top: size.height - 240,
                    right: 0,
                    child: SpeedWidget(videoController: videoController)),
            //
            // FullScreen
            //
            hover || almostFinished
                ? Container()
                : buttonCreator(
                    listenable: _fullHover,
                    icon: GestureDetector(
                      onTap: () {
                        FullScreen.setFullScreen(!isFullScreen);
                      },
                      child: Icon(
                        isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    addBottom: 2.0,
                    left: (size.width - 85).toInt(),
                  ),
            //
            // Hover Detection
            //
            MouseRegion(
              opaque: false,
              onHover: (event) {
                timer.cancel();
                timer = Timer(
                  _hoverOff,
                  () {
                    if (mounted) {
                      setState(() {
                        hover = true;
                      });
                    }
                  },
                );
                if (!played) {
                  ageTimerReset();
                }
                if (mounted) {
                  setState(() {
                    hover = false;
                  });
                }
              },
              child: SizedBox(width: size.width, height: size.height),
            ),
          ],
        ),
      ),
    );

    final loadingPage = SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(episodeContent.poster),
                fit: BoxFit.cover,
              ),
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: RotationTransition(
                turns: turnsTween.animate(_animation),
                child: Transform.scale(
                  scale: 0.3,
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
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content.title, style: headline3),
                Text(
                  'E${episode + 1} "${episodeContent.title}"',
                  style: headline2,
                ),
              ],
            ),
          )
        ],
      ),
    );

    final finishPage = SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(nextContent.poster),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: //arrowBack
                IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () {
                if (mounted) {
                  setState(
                    () {
                      hover = !hover;
                    },
                  );
                }

                Modular.to.pushReplacementNamed('/home');
                videoController.stop();
              },
            ),
          ),
          MouseRegion(
            opaque: false,
            onHover: (event) {
              if (mounted) {
                setState(() {
                  hover = true;
                });
              }
            },
            child: SizedBox(width: size.width, height: size.height),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: SizedBox(
              width: 205,
              child: hover
                  ? HomeButton(
                      textStyle: blackHeadline6,
                      overlayColor: Colors.grey.shade300.withValues(alpha: 0.5),
                      buttonColor: Colors.white,
                      icon: Icons.play_arrow,
                      text: 'Próximo Episodio',
                      padding: const EdgeInsets.only(left: 5, right: 0),
                      onPressed: () {
                        videoController.stop();

                        var playerNotifier = Modular.get<PlayerNotifier>();
                        playerNotifier.playerModel =
                            PlayerModel(content, nextEpisode);
                        Modular.to.popAndPushNamed('/video');
                      },
                    )
                  : SizedBox(
                      width: 212,
                      height: 40,
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: nextAnimation,
                            builder: (context, child) {
                              if (nextAnimation.value >= 0.99) {
                                // Use post-frame callback to avoid setState during build
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  videoController.stop();
                                  var playerNotifier =
                                      Modular.get<PlayerNotifier>();
                                  playerNotifier.playerModel =
                                      PlayerModel(content, nextEpisode);
                                  Modular.to.popAndPushNamed('/video');
                                });
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey.shade300
                                      .withValues(alpha: 0.7),
                                  color: Colors.white,
                                  minHeight: 40,
                                  value: nextAnimation.value,
                                ),
                              );
                            },
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Próximo Episodio',
                                  style: blackHeadline6,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );

    Widget currentPage = Container();
    currentPage = loaded ? loadedPage : loadingPage;
    currentPage = almostFinished ? almostFinishedPage : currentPage;
    currentPage = finished ? finishPage : currentPage;
    return KeyboardListener(
        autofocus: true,
        focusNode: _focusNode2,
        onKeyEvent: (value) async {
          if (value is KeyDownEvent && !kIsWeb) {
            if (value.logicalKey == LogicalKeyboardKey.f11) {
              await DesktopWindow.toggleFullScreen();
            }
          }
        },
        child: Scaffold(backgroundColor: backgroundColor, body: currentPage));
  }
}

class PlayerNotifier extends ChangeNotifier {
  int _selectedButton = 0;
  double _selectedSpeed = 1;
  int _selectedCaption = 0;
  int _selectedTranslation = 0;
  PlayerModel playerModel =
      PlayerModel(ContentModel.fromJson(AppConsts.placeholderJson), 0);

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
