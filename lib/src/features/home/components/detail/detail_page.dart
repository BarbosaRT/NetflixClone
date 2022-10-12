import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/components/profile_button.dart';
import 'package:netflix/src/features/home/components/detail/components/detail_container.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  late GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class DetailPage extends StatefulWidget {
  ContentModel? content;
  DetailPage({super.key, this.content});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final scrollController = ScrollController(initialScrollOffset: 0);
  static const transitionDuration = Duration(milliseconds: 300);
  final ValueNotifier<bool> _active = ValueNotifier(false);
  final double height = 1800.0;
  final double containerWidth = 1000;
  final VideoInterface videoController = GetImpl().getImpl(id: 2);
  int current = 0;
  bool initialised = false;

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    widget.content ??= ContentModel.fromJson(AppConsts.placeholderJson);
    super.initState();
    videoController.init(widget.content!.trailer,
        w: 1280, h: 720, callback: callback);
    videoController.defineThumbnail(widget.content!.poster);
    _active.value = false;
    Future.delayed(transitionDuration).then(
      (value) {
        _active.value = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final headline = AppFonts().headline6;
    final headline2 = AppFonts().headline8;
    final headline3 = AppFonts().labelBig;
    final headline4 = AppFonts().labelIntermedium.copyWith(color: Colors.white);
    final headline5 = AppFonts().headtext4;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;
    const overview =
        'Quando Walter White, um professor de quimica no Novo Mexico, é diagnosticado com cancer ele se une com, Jesse Pinkman, um ex-aluno para produzir cristais de metafetamina e assegurar o futuro de sua familia.';

    List<ProfileButton> castWidgets = [];
    for (int c = 0; c < widget.content!.cast!.length; c++) {
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

    List<ProfileButton> genreWidgets = [];
    for (int g = 0; g < widget.content!.tags.length; g++) {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: myGlobals.scaffoldKey,
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
                            height: height,
                            color: backgroundColor.withOpacity(0.5),
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
                              width: 860,
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
                                width: 860,
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
                          // Close Button
                          //
                          Positioned(
                            top: 70,
                            left: width - 310,
                            child: GestureDetector(
                              onTap: () {
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
                                          //widget.content!.overview,
                                          overview,
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
                              width: 750,
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
                            left: 300,
                            child: Column(
                              children: [
                                for (int e = 0;
                                    e < widget.content!.episodes!.length;
                                    e++)
                                  DetailContainer(
                                    key: UniqueKey(),
                                    content: ContentModel.fromMap(
                                        widget.content!.episodes![widget
                                            .content!.episodes!.keys
                                            .toList()[e]]),
                                    index: e,
                                  ),
                              ],
                            ),
                          ),
                          //
                          // About
                          //
                          Positioned(
                            top: 835 + 150.0 * widget.content!.episodes!.length,
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
                              ],
                            ),
                          ),

                          Positioned(
                            left: width - 13,
                            child: Container(
                              width: 15,
                              height: height,
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
