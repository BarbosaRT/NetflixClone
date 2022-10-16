import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/player/player_page.dart';

class SkipWidget extends StatefulWidget {
  final VideoInterface videoController;
  final Duration hover;
  final ContentModel content;
  final ContentModel nextContent;
  final int nextEpisode;
  const SkipWidget(
      {super.key,
      required this.videoController,
      required this.hover,
      required this.content,
      required this.nextContent,
      required this.nextEpisode});

  @override
  State<SkipWidget> createState() => _SkipWidgetState();
}

class _SkipWidgetState extends State<SkipWidget> {
  final ValueNotifier<bool> _skipHover = ValueNotifier(false);
  final ValueNotifier<bool> _contentHover = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final TextStyle headline2 = AppFonts().headline4.copyWith(fontSize: 24);
    final TextStyle headline3 = AppFonts().headline7;
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    final TextStyle headline = AppFonts().headline6;
    return HoverWidget(
      useNotification: false,
      delayOut: widget.hover,
      fadeDuration: Duration.zero,
      type: HoverType.top,
      rightPadding: 300,
      maxWidth: 550,
      maxHeight: 500,
      distance: 260,
      onHover: () {
        _skipHover.value = true;
      },
      onExit: () {
        _skipHover.value = false;
      },
      icon: GestureDetector(
        onTap: () {
          widget.videoController.stop();
          Modular.to.popAndPushNamed('/video',
              arguments: PlayerModel(widget.content, widget.nextEpisode));
        },
        child: ValueListenableBuilder(
          valueListenable: _skipHover,
          builder: (context, bool value, child) {
            return AnimatedScale(
              scale: value ? 1.4 : 1,
              duration: widget.hover,
              child: const Icon(Icons.skip_next, color: Colors.white, size: 50),
            );
          },
        ),
      ),
      child: Container(
          width: 550,
          height: 250,
          color: backgroundColor,
          child: Column(
            children: [
              Container(
                width: 550,
                height: 70,
                color: colorController.currentScheme.likeButtonColor,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Próximo Episodio',
                    style: headline2,
                  ),
                ),
              ),
              MouseRegion(
                onHover: (v) {
                  _contentHover.value = true;
                },
                onExit: (v) {
                  _contentHover.value = false;
                },
                child: Container(
                  width: 550,
                  height: 180,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Container(
                              width: 200,
                              height: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        widget.nextContent.poster,
                                      ),
                                      fit: BoxFit.fill)),
                              child: ValueListenableBuilder(
                                valueListenable: _contentHover,
                                builder: (context, bool value, child) {
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: value ? 1 : 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(40),
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                          ),
                                          child: const Icon(Icons.play_arrow,
                                              color: Colors.white, size: 40)),
                                    ),
                                  );
                                },
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 270,
                                  child: Text(
                                    '${widget.nextEpisode + 1}   ${widget.nextContent.title}',
                                    style: headline,
                                  ),
                                ),
                                SizedBox(
                                  width: 270,
                                  child: Text(widget.nextContent.overview,
                                      style: headline3),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
