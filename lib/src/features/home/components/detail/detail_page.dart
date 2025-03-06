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
  final double containerWidth = 1000;
  final VideoInterface videoController = GetImpl().getImpl(id: 2);

  void callback() {
    if (mounted) {
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
      if (!contentController.loading) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    videoController.init(widget.content!.trailer,
        w: 1280, h: 720, callback: callback);
    videoController.defineThumbnail(
        widget.content!.poster, widget.content!.isOnline);
    _active.value = false;
    Future.delayed(transitionDuration).then(
      (value) {
        _active.value = true;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(trailerDelay).then((value) {
        if (mounted) {
          setState(() {
            videoController.enableFrame(true);
            videoController.play();
            videoController.setVolume(0);
          });
        }
      });
    });
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 750,
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
                        o < (value ? 6 : 3) && 3 * o < contents.length;
                        o++)
                      SizedBox(
                        width: 1000,
                        height: 380,
                        child: Stack(
                          children: [
                            for (int c = 0; c < 3; c++)
                              if (3 * o + c < contents.length)
                                Positioned(
                                  left: c * 236 + c * 20,
                                  child: Transform.scale(
                                    scale: width / 1360,
                                    child: DetailContent(
                                      content: contents[3 * o + c],
                                    ),
                                  ),
                                ),
                          ].reversed.toList(),
                        ),
                      ),
                  ],
                );
              },
            )
          ],
        );
      },
    );

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
                            width: width - 500,
                            height: height,
                            color: backgroundColor,
                          ),
                          //
                          // Video
                          //
                          Positioned(
                            top: 70,
                            left: 250,
                            child: SizedBox(
                              width: width - 500,
                              height: 500,
                              child: videoController.frame(),
                            ),
                          ),
                          //
                          // Video Gradient
                          //
                          Positioned(
                              top: 350,
                              left: 250,
                              child: Container(
                                height: 400,
                                width: width - 500,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    backgroundColor.withAlpha(0),
                                    backgroundColor,
                                    backgroundColor,
                                  ],
                                )),
                              )),
                          //
                          // Logo
                          //
                          Positioned(
                              top: 360,
                              left: 300,
                              child: Image.asset(
                                widget.content!.logo,
                                height: 100,
                              )),
                          //
                          // Buttons
                          //
                          Positioned(
                            top: 460,
                            left: 300,
                            child: HomeButton(
                              textStyle: blackHeadline6,
                              overlayColor: Colors.grey.shade300,
                              buttonColor: Colors.white,
                              icon: Icons.play_arrow,
                              text: 'Assistir',
                              onPressed: () {
                                videoController.setVolume(0);
                                Future.delayed(trailerDelay).then((value) {
                                  videoController.setVolume(0);
                                  videoController.stop();
                                });
                                var playerNotifier =
                                    Modular.get<PlayerNotifier>();
                                playerNotifier.playerModel =
                                    PlayerModel(widget.content!, 0);
                                Modular.to.pushNamed(
                                  '/video',
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 390,
                            left: 345,
                            child: ContentButton(
                                onClick: () {
                                  added.value = !added.value;
                                },
                                text: ValueListenableBuilder(
                                  valueListenable: added,
                                  builder: (BuildContext context, bool value,
                                      child) {
                                    return Text(
                                      value
                                          ? 'Remover da Minha lista'
                                          : 'Adicionar à Minha lista',
                                      textAlign: TextAlign.center,
                                      style: headline.copyWith(
                                          color: Colors.black),
                                    );
                                  },
                                ),
                                icon: ValueListenableBuilder(
                                  valueListenable: added,
                                  builder: (BuildContext context, bool value,
                                      child) {
                                    return Icon(
                                      value ? Icons.done : Icons.add,
                                      size: 25,
                                      color: Colors.white,
                                    );
                                  },
                                )),
                          ),
                          const Positioned(
                            top: 390,
                            left: 345,
                            child: LikeButton(),
                          ),
                          Positioned(
                            top: 457,
                            right: 300,
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
                            left: width - 310,
                            child: GestureDetector(
                              onTap: () {
                                videoController.stop();
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
                            left: 300,
                            width: width - 500,
                            child: Row(
                              children: [
                                //
                                // Details
                                //
                                SizedBox(
                                  height: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      // Details
                                      //
                                      Row(
                                        children: [
                                          Text(
                                            '${widget.content!.rating}% relevante',
                                            style: headline.copyWith(
                                                color: Colors.green),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '2022',
                                            style: headline,
                                          ),
                                          const SizedBox(width: 8),
                                          //
                                          Image.asset(
                                            AppConsts.classifications[
                                                    widget.content!.age] ??
                                                'assets/images/classifications/L.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            widget.content!.detail,
                                            style: headline,
                                          ),
                                          const SizedBox(width: 5),
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
                                        width: 480,
                                        child: Text(
                                          widget.content!.overview,
                                          //overview,
                                          style: headline2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //
                                // Cast
                                //
                                const SizedBox(
                                  width: 20,
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 300,
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
                              ],
                            ),
                          ),
                          //
                          // Episodes
                          //
                          Positioned(
                            top: 750,
                            left: 300,
                            child: SizedBox(
                              height: 100,
                              width: width - 570,
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
                            left: 280 * width / 1360,
                            child: Column(
                              children: [
                                for (int e = 0; e < episodes; e++)
                                  Transform.scale(
                                    scale: width / 1360,
                                    child: DetailContainer(
                                      key: UniqueKey(),
                                      content: widget.content!,
                                      index: e,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          //
                          // Titulos Semelhantes
                          //
                          Positioned(
                            top: 835 + 150.0 * episodes,
                            left: 300 * width / 1360,
                            child: similarTitles,
                          ),
                          //
                          // About
                          //
                          ValueListenableBuilder(
                            valueListenable: _expanded,
                            builder: (context, bool value, child) {
                              return Positioned(
                                top: 1900 +
                                    150.0 * episodes +
                                    400 * (value ? 3 : 0),
                                child: Stack(
                                  children: [
                                    //
                                    // Background
                                    //
                                    Container(
                                        width: width - 500,
                                        height: 1000,
                                        color: Colors.transparent),
                                    Container(
                                      width: width - 500,
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
                                          width: width - 500,
                                          height: 1000,
                                          color: backgroundColor),
                                    ),
                                    Positioned(
                                        top: 50,
                                        left: 25 * width / 1360,
                                        child: Container(
                                            width: width - 550,
                                            height: 2,
                                            color: Colors.grey.shade800)),
                                    //
                                    // Expand Button
                                    //
                                    Positioned(
                                      top: 30,
                                      left: 20,
                                      child: Container(
                                        width: width - 500,
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
                                            builder:
                                                (context, bool value, child) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _expanded.value =
                                                      !_expanded.value;
                                                  if (!_expanded.value) {
                                                    scrollController.jumpTo(
                                                        startHeight / 2);
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
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
                                                for (int k =
                                                        castWidgets.length - 1;
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
                                                          widget
                                                              .content!.age] ??
                                                      'assets/images/classifications/L.png',
                                                  width: 30,
                                                  height: 30,
                                                )
                                              ],
                                            ),
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
                        ]),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
