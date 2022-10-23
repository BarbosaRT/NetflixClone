import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/player/player_page.dart';
import 'package:path_drawing/path_drawing.dart';

class TranslationWidget extends StatefulWidget {
  const TranslationWidget({super.key});

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  final scrollController = ScrollController(initialScrollOffset: 0);
  final Path icon = parseSvgPathData(
      'M0 4C0 3.44772 0.447715 3 1 3H23C23.5523 3 24 3.44772 24 4V16C24 16.5523 23.5523 17 23 17H19V20C19 20.3688 18.797 20.7077 18.4719 20.8817C18.1467 21.0557 17.7522 21.0366 17.4453 20.8321L11.6972 17H1C0.447715 17 0 16.5523 0 16V4ZM2 5V15H12H12.3028L12.5547 15.1679L17 18.1315V16V15H18H22V5H2ZM10 9H4V7H10V9ZM20 11H14V13H20V11ZM12 13H4V11H12V13ZM20 7H12V9H20V7Z');
  static const List<String> translations = [
    'portugues [original]',
    'inglês',
    'francês',
    'espanhol',
    'alemão'
  ];
  static const List<String> captions = [
    'desligadas',
    'portugues',
    'italiano',
    'alemão',
    'inglês (CC)',
    'francês'
  ];
  static const List<String> captions2 = [
    'chines simplificado',
    'chines tradicional',
    'coreano',
    'croata',
    'dinamarquês',
    'espanhol',
    'grego',
    'hebraico',
    'português europeu',
    'romeno',
    'russo',
    'sueco'
  ];
  bool hover = false;
  static const Duration duration = Duration(milliseconds: 100);
  @override
  Widget build(BuildContext context) {
    final TextStyle headline = AppFonts().headline4.copyWith(fontSize: 22);
    final colorController = Modular.get<ColorController>();
    final containerColor = colorController.currentScheme.likeButtonColor;

    return HoverWidget(
      useNotification: false,
      delayOut: Duration.zero,
      fadeDuration: Duration.zero,
      type: HoverType.top,
      rightPadding: 220,
      maxWidth: 450,
      maxHeight: 600,
      distance: 510,
      onHover: () {
        if (!hover) {
          setState(() {
            hover = true;
          });
        }
      },
      onExit: () {
        setState(() {
          hover = false;
        });
      },
      icon: Padding(
        padding: const EdgeInsets.only(left: 15, top: 17),
        child: AnimatedScale(
          duration: duration,
          scale: hover ? 1.2 : 1,
          child: Transform.scale(
              scale: 1.7,
              child: AppConsts()
                  .createIcon(icon, Colors.white, const Size(40, 40))),
        ),
      ),
      child: Container(
          width: 450,
          height: 490,
          color: containerColor,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 10),
                    child: Text(
                      'Idioma',
                      style: headline,
                    ),
                  ),
                  for (int t = 0; t < translations.length; t++)
                    TranslationButton(
                      title: translations[t],
                      index: t,
                      isTranslation: true,
                    )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 10),
                    child: Text(
                      'Legenda',
                      style: headline,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 450,
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      controller: scrollController,
                      child: SmoothScroll(
                        scrollSpeed: 90,
                        scrollAnimationLength: 150,
                        curve: Curves.decelerate,
                        controller: scrollController,
                        child: ListView(
                          controller: scrollController,
                          children: [
                            for (int c = 0; c < captions.length; c++)
                              TranslationButton(
                                title: captions[c],
                                index: c,
                                isTranslation: false,
                              ),
                            Container(
                              width: 240,
                              height: 30,
                              alignment: Alignment.center,
                              child: Container(
                                  width: 150, height: 3, color: Colors.grey),
                            ),
                            for (int c = 0; c < captions2.length; c++)
                              TranslationButton(
                                title: captions2[c],
                                index: captions.length + c,
                                isTranslation: false,
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class TranslationButton extends StatefulWidget {
  final int index;
  final bool isTranslation;
  final String title;
  const TranslationButton(
      {super.key,
      required this.index,
      required this.isTranslation,
      required this.title});

  @override
  State<TranslationButton> createState() => _TranslationButtonState();
}

class _TranslationButtonState extends State<TranslationButton> {
  bool _hover = false;
  bool clicked = false;
  @override
  void initState() {
    final translationController = Modular.get<PlayerNotifier>();
    translationController.addListener(() {
      if (mounted) {
        int t = widget.isTranslation
            ? translationController.getTranslation()
            : translationController.getCaption();
        setState(() {
          clicked = t == widget.index;
        });
      }
    });
    int t = widget.isTranslation
        ? translationController.getTranslation()
        : translationController.getCaption();
    clicked = t == widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headline2 = AppFonts()
        .headline8
        .copyWith(fontWeight: FontWeight.w100, color: Colors.grey.shade400);
    final translationController = Modular.get<PlayerNotifier>();
    final colorController = Modular.get<ColorController>();
    final containerColor = colorController.currentScheme.likeButtonColor;
    final highlightColor = colorController.currentScheme.containerColor2;
    return MouseRegion(
      onHover: (v) {
        if (mounted) {
          setState(() {
            _hover = true;
          });
        }
      },
      onExit: (v) {
        if (mounted) {
          setState(() {
            _hover = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.isTranslation) {
            translationController.changeTranslation(widget.index);
          } else {
            translationController.changeCaption(widget.index);
          }
        },
        child: Container(
            width: 230,
            height: 40,
            color: _hover ? highlightColor : containerColor,
            child: Row(
              children: [
                SizedBox(
                    width: 50,
                    height: 40,
                    child: clicked
                        ? const Icon(Icons.done, color: Colors.white)
                        : Container()),
                Text(
                  widget.title,
                  style: headline2,
                )
              ],
            )),
      ),
    );
  }
}
