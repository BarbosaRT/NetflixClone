import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/core/colors/color_controller.dart';
import 'package:oldflix/core/fonts/app_fonts.dart';
import 'package:oldflix/core/smooth_scroll.dart';
import 'package:oldflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:oldflix/src/features/player/player_page.dart';

class TranslationWidget extends StatefulWidget {
  const TranslationWidget({super.key});

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  final scrollController = ScrollController(initialScrollOffset: 0);
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
      rightPadding: 230,
      maxWidth: 450,
      maxHeight: 600,
      distance: 495,
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
            child: const Icon(Icons.subtitles, size: 40, color: Colors.white)),
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
                    height: 440,
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
