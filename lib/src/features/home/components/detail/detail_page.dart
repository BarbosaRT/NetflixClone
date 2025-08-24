// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/components/profile_button.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';
import 'package:netflix/src/features/home/components/content_list/components/like_button.dart';
import 'package:netflix/src/features/home/components/detail/components/detail_container.dart';
import 'package:netflix/src/features/home/components/detail/components/detail_content.dart';
import 'package:netflix/src/features/home/components/home_button.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:netflix/src/features/player/player_page.dart';

DetailGlobals detailGlobals = DetailGlobals();

class DetailGlobals {
  late GlobalKey _scaffoldKey;
  VideoInterface? videoController;

  DetailGlobals() {
    _scaffoldKey = GlobalKey();
  }

  GlobalKey get scaffoldKey => _scaffoldKey;
}

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  ContentModel? content;
  DetailPage({super.key, this.content});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final scrollController = ScrollController(initialScrollOffset: 0);
  static const transitionDuration = Duration(milliseconds: 300);

  static const trailerDelay = Duration(seconds: 10);

  final ValueNotifier<bool> _active = ValueNotifier(false);
  final ValueNotifier<bool> _hover = ValueNotifier(false);
  final ValueNotifier<bool> _expanded = ValueNotifier(false);
  final ValueNotifier<bool> added = ValueNotifier(false);

  final double startHeight = 2150.0;
  double height = 2000.0;
  final VideoInterface videoController = GetImpl().getImpl(id: 2);
  bool _isDisposed = false;

  void callback() {
    if (mounted && !_isDisposed) {
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.content ??= ContentModel.fromJson(AppConsts.placeholderJson);
    final contentController = Modular.get<ContentController>();
    if (contentController.loading) {
      contentController.init();
    }
    final episodes = (widget.content!.episodes != null)
        ? widget.content!.episodes!.length
        : 0;
    height = startHeight + 410 * (_expanded.value ? 2 : 0) + 150.0 * episodes;
    super.initState();

    contentController.addListener(() {
      if (!contentController.loading && mounted && !_isDisposed) {
        setState(() {});
      }
    });

    // Initialize video controller with proper error handling
    try {
      videoController.init(widget.content!.trailer,
          w: 1280, h: 720, callback: callback);
      videoController.defineThumbnail(
          widget.content!.poster, widget.content!.isOnline);
      // Set the video controller reference in DetailGlobals
      detailGlobals.videoController = videoController;
    } catch (e) {
      print('Error initializing video controller: $e');
    }

    _active.value = false;
    Future.delayed(transitionDuration).then(
      (value) {
        if (mounted && !_isDisposed) {
          _active.value = true;
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(trailerDelay).then((value) {
        if (mounted && !_isDisposed) {
          try {
            setState(() {
              videoController.enableFrame(true);
              videoController.play();
              videoController.setVolume(0);
            });
          } catch (e) {
            print('Error playing video: $e');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      videoController.stop();
    } catch (e) {
      print('Error disposing video controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentController = Modular.get<ContentController>();

    double width = MediaQuery.of(context).size.width;
    final headline = AppFonts().headline6;
    final headline2 = AppFonts().headline8;
    final headline3 = AppFonts().labelBig;
    final headline4 = AppFonts().labelIntermedium.copyWith(color: Colors.white);
    final headline5 = AppFonts().headtext4;

    final blackHeadline6 =
        headline.copyWith(color: Colors.black, fontWeight: FontWeight.w900);
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;
    //const overview =
    //    'Quando Walter White, um professor de quimica no Novo Mexico, é diagnosticado com cancer ele se une com, Jesse Pinkman, um ex-aluno para produzir cristais de metafetamina e assegurar o futuro de sua familia.';

    List<ProfileButton> castWidgets = [];
    final episodes = (widget.content!.episodes != null)
        ? widget.content!.episodes!.length
        : 0;

    final cast =
        (widget.content!.cast != null) ? widget.content!.cast!.length : 0;

    for (int c = 0; c < cast; c++) {
      final text = widget.content!.cast![c] + ', ';
      final textSpan = TextSpan(
        text: text,
        style: headline4,
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      castWidgets.add(ProfileButton(
          width: tp.width,
          showPicture: false,
          textColor: Colors.white,
          alignment: Alignment.centerLeft,
          height: 20,
          underline: 2,
          textStyle: headline4,
          text: text));
    }
    if (cast == 0) {
      const text = "Blueberries";
      final textSpan = TextSpan(
        text: text,
        style: headline4,
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      castWidgets.add(ProfileButton(
          width: tp.width,
          showPicture: false,
          textColor: Colors.white,
          alignment: Alignment.centerLeft,
          height: 20,
          underline: 2,
          textStyle: headline4,
          text: text));
    }
    final tags = (widget.content != null) ? widget.content!.tags.length : 0;
    List<ProfileButton> genreWidgets = [];
    for (int g = 0; g < tags; g++) {
      final t = widget.content!.tags[g] + ', ';
      final tSpan = TextSpan(
        text: t,
        style: headline4,
      );
      final tP = TextPainter(text: tSpan, textDirection: TextDirection.ltr);
      tP.layout();
      genreWidgets.add(ProfileButton(
          width: tP.width,
          showPicture: false,
          textColor: Colors.white,
          alignment: Alignment.centerLeft,
          height: 20,
          underline: 2,
          textStyle: headline4,
          text: t));
    }

    Widget similarTitles = ValueListenableBuilder(
      valueListenable: _expanded,
      builder: (context, bool value, child) {
        // Responsive calculations
        final availableWidth = width - (width < 1280 ? 300 : 600);
        final minContainerWidth = width < 600
            ? 180.0
            : width < 1200
                ? 200.0
                : 220.0;
        final spacing = width < 600 ? 15.0 : 20.0;

        // Calculate optimal number of items per row (2-4)
        int itemsPerRow = 2;
        for (int items = 4; items >= 2; items--) {
          final totalSpacing = (items - 1) * spacing;
          final requiredWidth = items * minContainerWidth + totalSpacing;
          if (requiredWidth <= availableWidth) {
            itemsPerRow = items;
            break;
          }
        }

        // Calculate container width to fill available space
        final totalSpacing = (itemsPerRow - 1) * spacing;
        final containerWidth = (availableWidth - totalSpacing) / itemsPerRow;
        final totalRowWidth = availableWidth;
        // Calculate container height proportionally to maintain aspect ratio
        final containerHeight =
            containerWidth * 1.5 + 20; // Aspect ratio + padding

        // Responsive title width
        final titleWidth = width < 600 ? 400.0 : 750.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: titleWidth,
              child: Text('Titulos Semelhantes ', style: headline5),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<List<ContentModel>>(
              stream: contentController
                  .getListContent(contentController.getKey(4))
                  .asBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                List<ContentModel> contents = snapshot.data!;
                return Column(
                  children: [
                    for (int o = 0;
                        o < (value ? 6 : 3) &&
                            itemsPerRow * o < contents.length;
                        o++)
                      SizedBox(
                        width: totalRowWidth,
                        height: containerHeight,
                        child: Stack(
                          children: [
                            for (int c = 0; c < itemsPerRow; c++)
                              if (itemsPerRow * o + c < contents.length)
                                Positioned(
                                  left: c * (containerWidth + spacing),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: spacing),
                                    child: DetailContent(
                                      content: contents[itemsPerRow * o + c],
                                      containerWidth: containerWidth,
                                    ),
                                  ),
                                ),
                          ].reversed.toList(),
                        ),
                      ),
                    // Add padding below the containers
                    SizedBox(
                      height: width < 600
                          ? 20.0
                          : width < 1200
                              ? 30.0
                              : 40.0,
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );

    videoController.changeSize(width, width / (16 / 9));

    final videoWidth = width - (width < 1280 ? 200 : 500);
    final videoHeight = videoWidth / (16 / 9);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: detailGlobals.scaffoldKey,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        //
        child: ValueListenableBuilder(
          valueListenable: _active,
          builder: (context, bool value, child) {
            //
            return Scrollbar(
              trackVisibility: value,
              thumbVisibility: value,
              controller: scrollController,
              child: SmoothScroll(
                scrollSpeed: 90,
                scrollAnimationLength: 150,
                curve: Curves.decelerate,
                controller: scrollController,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      //
                      // Background
                      //
                      Container(
                        width: width,
                        height: height + 50,
                        color: backgroundColor.withValues(alpha: 0.5),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        width: videoWidth,
                        height: height,
                        color: backgroundColor,
                      ),
                      //
                      // Video
                      //
                      Positioned(
                        top: 50,
                        left: (width < 1280 ? 100 : 250),
                        child: SizedBox(
                          width: videoWidth - 1,
                          height: videoHeight,
                          child: _isDisposed
                              ? Container(color: Colors.black)
                              : videoController.frame(),
                        ),
                      ),
                      //
                      // Video Gradient
                      //
                      Positioned(
                        top: 350,
                        left: (width < 1280 ? 100 : 250),
                        child: Container(
                          height: 400,
                          width: videoWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                backgroundColor.withAlpha(0),
                                backgroundColor,
                                backgroundColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      // Video Cover
                      //
                      Positioned(
                        top: 650,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          width: videoWidth,
                          height: 500,
                          color: backgroundColor,
                        ),
                      ),
                      //
                      // Logo
                      //
                      Positioned(
                        top: 360,
                        left: (width < 1280 ? 150 : 300),
                        child: Image.asset(
                          widget.content!.logo,
                          height: 100,
                        ),
                      ),
                      //
                      // Buttons
                      //
                      Positioned(
                        top: 460,
                        left: (width < 1280 ? 150 : 300),
                        child: HomeButton(
                          textStyle: blackHeadline6,
                          overlayColor: Colors.grey.shade300,
                          buttonColor: Colors.white,
                          icon: Icons.play_arrow,
                          text: 'Assistir',
                          onPressed: () {
                            try {
                              if (!_isDisposed) {
                                videoController.setVolume(0);
                                Future.delayed(trailerDelay).then((value) {
                                  try {
                                    if (!_isDisposed) {
                                      videoController.setVolume(0);
                                      videoController.stop();
                                    }
                                  } catch (e) {
                                    print('Error in delayed video stop: $e');
                                  }
                                });
                              }
                            } catch (e) {
                              print('Error setting video volume: $e');
                            }
                            var playerNotifier = Modular.get<PlayerNotifier>();
                            playerNotifier.playerModel =
                                PlayerModel(widget.content!, 0);
                            videoController.pause();
                            Modular.to.pushNamed(
                              '/video',
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 390,
                        left: (width < 1280 ? 195 : 345),
                        child: ContentButton(
                          onClick: () {
                            added.value = !added.value;
                          },
                          text: ValueListenableBuilder(
                            valueListenable: added,
                            builder: (BuildContext context, bool value, child) {
                              return Text(
                                value
                                    ? 'Remover da Minha lista'
                                    : 'Adicionar à Minha lista',
                                textAlign: TextAlign.center,
                                style: headline.copyWith(color: Colors.black),
                              );
                            },
                          ),
                          icon: ValueListenableBuilder(
                            valueListenable: added,
                            builder: (BuildContext context, bool value, child) {
                              return Icon(
                                value ? Icons.done : Icons.add,
                                size: 25,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 390,
                        left: (width < 1280 ? 195 : 345),
                        child: LikeButton(),
                      ),
                      if (!_isDisposed)
                        Positioned(
                          top: 457,
                          right: (width < 1280 ? 150 : 300),
                          child: VolumeButton(
                            videoController: videoController,
                            iconOn: Icons.volume_up,
                            iconOff: Icons.volume_off,
                            scale: 1.15,
                          ),
                        ),
                      //
                      // Close Button
                      //
                      Positioned(
                        top: 70,
                        left: width - (width < 1280 ? 160 : 310),
                        child: GestureDetector(
                          onTap: () {
                            try {
                              if (!_isDisposed) {
                                videoController.stop();
                              }
                            } catch (e) {
                              print('Error stopping video controller: $e');
                            }
                            _active.value = false;
                            Modular.to.navigate('/home');
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: _active.value
                                      ? Colors.transparent
                                      : Colors.white,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 30, color: Colors.white),
                          ),
                        ),
                      ),
                      //
                      // Details
                      //
                      Positioned(
                        top: 580,
                        left: (width < 1280 ? 150 : 300),
                        width: width - (width < 1280 ? 300 : 500),
                        child: Row(
                          children: [
                            //
                            // Details
                            //
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    // Details
                                    //
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        Text(
                                          '${widget.content!.rating}% relevante',
                                          style: headline.copyWith(
                                              color: Colors.green),
                                        ),
                                        Text(
                                          '2022',
                                          style: headline,
                                        ),
                                        //
                                        Image.asset(
                                          AppConsts.classifications[
                                                  widget.content!.age] ??
                                              'assets/images/classifications/L.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text(
                                          widget.content!.detail,
                                          style: headline,
                                        ),
                                        Container(
                                          height: 20,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              color: Colors.transparent),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1),
                                            child: Center(
                                              child: Text(
                                                'HD',
                                                style: headline.copyWith(
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    // Overview
                                    //
                                    Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      height: 100,
                                      child: Text(
                                        widget.content!.overview,
                                        //overview,
                                        style: headline2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //
                            // Cast
                            //
                            if (width >= 1280) ...[
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 250,
                                        child: LayoutGrid(
                                          gridFit: GridFit.loose,
                                          columnSizes: const [
                                            auto,
                                            auto,
                                          ],
                                          columnGap: 0,
                                          rowSizes: const [
                                            auto,
                                            auto,
                                          ],
                                          children: [
                                            Text(
                                              'Elenco:',
                                              style: headline3,
                                            ),
                                            for (int k = 0;
                                                k < castWidgets.length;
                                                k++)
                                              castWidgets[k],
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60,
                                        width: 250,
                                        child: LayoutGrid(
                                          gridFit: GridFit.loose,
                                          columnSizes: const [
                                            auto,
                                            auto,
                                          ],
                                          columnGap: 5,
                                          rowSizes: const [auto, auto],
                                          children: [
                                            Text(
                                              'Generos:',
                                              style: headline3,
                                            ),
                                            for (int j = 0;
                                                j < genreWidgets.length;
                                                j++)
                                              genreWidgets[j],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      //
                      // Episodes
                      //
                      Positioned(
                        top: 750,
                        left: (width < 1280 ? 150 : 300),
                        child: SizedBox(
                          height: 100,
                          width: width - (width < 1280 ? 400 : 600),
                          child: Row(
                            children: [
                              Text(
                                'Episodios',
                                style: headline5,
                              ),
                              const Spacer(),
                              Text(widget.content!.title, style: headline5),
                            ],
                          ),
                        ),
                      ),
                      //
                      // Episodes Container
                      //
                      Positioned(
                        top: 835,
                        left: (width < 1280 ? 130 : 280),
                        child: Column(
                          children: [
                            for (int e = 0; e < episodes; e++)
                              DetailContainer(
                                key: UniqueKey(),
                                content: widget.content!,
                                index: e,
                              ),
                          ],
                        ),
                      ),
                      //
                      // Titulos Semelhantes
                      //
                      Positioned(
                        top: 835 + 150.0 * episodes,
                        left: (width < 1280 ? 150 : 300),
                        child: similarTitles,
                      ),
                      //
                      // About
                      //
                      ValueListenableBuilder(
                        valueListenable: _expanded,
                        builder: (context, bool value, child) {
                          return Positioned(
                            top:
                                1900 + 110.0 * episodes + 400 * (value ? 3 : 0),
                            child: Stack(
                              children: [
                                //
                                // Background
                                //
                                Container(
                                    width: width - (width < 1280 ? 300 : 500),
                                    height: 1020,
                                    color: Colors.transparent),
                                Container(
                                  width: width - (width < 1280 ? 300 : 500),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          backgroundColor.withAlpha(0),
                                          backgroundColor
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  child: Container(
                                      width: width - (width < 1280 ? 300 : 500),
                                      height: 1000,
                                      color: backgroundColor),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 25,
                                  child: Container(
                                    width: width - -(width < 1280 ? 350 : 550),
                                    height: 2,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                //
                                // Expand Button
                                //
                                Positioned(
                                  top: 30,
                                  left: 20,
                                  child: Container(
                                    width: width - (width < 1280 ? 300 : 500),
                                    height: 40,
                                    alignment: Alignment.topCenter,
                                    child: HoverWidget(
                                      useNotification: false,
                                      delayOut: Duration.zero,
                                      fadeDuration: Duration.zero,
                                      maxWidth: 40,
                                      maxHeight: 40,
                                      rightPadding: 40,
                                      detectChildArea: false,
                                      onExit: () {
                                        _hover.value = false;
                                      },
                                      onHover: () {
                                        _hover.value = true;
                                      },
                                      icon: ValueListenableBuilder(
                                        valueListenable: _hover,
                                        builder: (context, bool value, child) {
                                          return GestureDetector(
                                            onTap: () {
                                              _expanded.value =
                                                  !_expanded.value;
                                              if (!_expanded.value) {
                                                scrollController
                                                    .jumpTo(startHeight / 2);
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  height = startHeight +
                                                      410 *
                                                          (_expanded.value
                                                              ? 3
                                                              : 0) +
                                                      150.0 * episodes;
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1),
                                                  shape: BoxShape.circle,
                                                  color: value
                                                      ? Colors.grey.shade700
                                                          .withValues(
                                                              alpha: 0.1)
                                                      : Colors.grey.shade900
                                                          .withValues(
                                                              alpha: 0.1)),
                                              child: const Icon(
                                                  Icons.expand_more_rounded,
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                //
                                // About
                                //
                                Positioned(
                                  top: 100,
                                  left: 20,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 750,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Sobre ',
                                              style: headline5.copyWith(
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                            Text(
                                              widget.content!.title,
                                              style: headline5.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 750,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Criação: ',
                                              style: headline3,
                                            ),
                                            castWidgets[0]
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //
                                      // Elenco
                                      //
                                      SizedBox(
                                        width: 750,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Elenco: ',
                                              style: headline3,
                                            ),
                                            for (int k = castWidgets.length - 1;
                                                k > 0;
                                                k--)
                                              castWidgets[k],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //
                                      // Generos
                                      //
                                      SizedBox(
                                        width: 750,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Generos: ',
                                              style: headline3,
                                            ),
                                            for (int j = 0;
                                                j < genreWidgets.length;
                                                j++)
                                              genreWidgets[j],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 750,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Classificação etária:  ',
                                              style: headline3,
                                            ),
                                            Image.asset(
                                              AppConsts.classifications[
                                                      widget.content!.age] ??
                                                  'assets/images/classifications/L.png',
                                              width: 30,
                                              height: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      Positioned(
                        left: width - 13,
                        child: Container(
                          width: 15,
                          height: height + 50,
                          color: value ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
