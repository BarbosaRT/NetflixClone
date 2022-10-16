import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/player/player_page.dart';
import 'package:path_drawing/path_drawing.dart';

class EpisodesList extends StatefulWidget {
  final VideoInterface videoController;
  final Duration hover;
  final ContentModel content;
  final ContentModel episodeContent;
  final int episode;
  const EpisodesList(
      {super.key,
      required this.videoController,
      required this.hover,
      required this.content,
      required this.episodeContent,
      required this.episode});

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  final scrollController = ScrollController(initialScrollOffset: 0);
  final Path listIcon = parseSvgPathData(
      'M8 5H22V13H24V5C24 3.89543 23.1046 3 22 3H8V5ZM18 9H4V7H18C19.1046 7 20 7.89543 20 9V17H18V9ZM0 13C0 11.8954 0.895431 11 2 11H14C15.1046 11 16 11.8954 16 13V19C16 20.1046 15.1046 21 14 21H2C0.895431 21 0 20.1046 0 19V13ZM14 19V13H2V19H14Z');
  bool hovered = false;

  static const Duration duration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final TextStyle headline2 = AppFonts().headline4.copyWith(fontSize: 24);
    final colorController = Modular.get<ColorController>();

    final backgroundColor = colorController.currentScheme.likeButtonColor;
    final episodes = widget.content.episodes!;

    final episodeController = Modular.get<PlayerNotifier>();

    return HoverWidget(
      useNotification: false,
      delayOut: widget.hover,
      fadeDuration: Duration.zero,
      type: HoverType.top,
      rightPadding: 280,
      maxWidth: 600,
      maxHeight: 900,
      distance: 505,
      onHover: () {
        if (!hovered) {
          episodeController.changeSelected(widget.episode);

          setState(() {
            hovered = true;
          });
        }
      },
      onExit: () {
        setState(() {
          hovered = false;
        });
      },
      icon: AnimatedScale(
        duration: duration,
        scale: hovered ? 1.25 : 1,
        child: Transform.scale(
            scale: 1.5,
            child: AppConsts()
                .createIcon(listIcon, Colors.white, const Size(40, 40))),
      ),
      child: Container(
        width: 600,
        height: 480,
        color: backgroundColor,
        child: Column(children: [
          Container(
            width: 600,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.content.title,
                style: headline2,
              ),
            ),
          ),
          SizedBox(
            width: 600,
            height: 420,
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
                    for (int c = 0; c < widget.content.episodes!.length; c++)
                      EpisodeContainer(
                          onClick: (episode) {
                            widget.videoController.stop();
                            Modular.to.popAndPushNamed('/video',
                                arguments:
                                    PlayerModel(widget.content, episode));
                          },
                          currentEpisode: widget.episode,
                          episode: c,
                          episodeContent: ContentModel.fromMap(
                              episodes[episodes.keys.toList()[c]])),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class EpisodeContainer extends StatefulWidget {
  final void Function(int episode) onClick;
  final ContentModel episodeContent;
  final int episode;
  final int currentEpisode;
  const EpisodeContainer(
      {super.key,
      required this.onClick,
      required this.episodeContent,
      required this.episode,
      required this.currentEpisode});

  @override
  State<EpisodeContainer> createState() => _EpisodeContainerState();
}

class _EpisodeContainerState extends State<EpisodeContainer> {
  bool _containerHover = false;
  bool clicked = false;

  static const Duration _animation = Duration(milliseconds: 200);

  @override
  void initState() {
    final episodeController = Modular.get<PlayerNotifier>();
    episodeController.addListener(() {
      if (mounted) {
        setState(() {
          clicked = episodeController.getSelected() == widget.episode;
        });
      }
    });
    clicked = episodeController.getSelected() == widget.episode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headline2 = AppFonts().headline6.copyWith(fontSize: 17);
    final colorController = Modular.get<ColorController>();

    final backgroundColor = colorController.currentScheme.likeButtonColor;
    final highlightColor = colorController.currentScheme.containerColor3;
    final clickedColor = colorController.currentScheme.darkBackgroundColor;

    final episodeController = Modular.get<PlayerNotifier>();
    final contentRow = Row(
      children: [
        const SizedBox(
          width: 40,
        ),
        Text(
          '${widget.episode + 1}   ${widget.episodeContent.title}',
          style: headline2,
        ),
        const Spacer(),
        Container(width: 100, height: 5, color: Colors.grey),
        const SizedBox(
          width: 30,
        ),
      ],
    );
    return MouseRegion(
        onHover: (v) {
          if (mounted) {
            setState(() {
              _containerHover = true;
            });
          }
        },
        onExit: (v) {
          if (mounted) {
            setState(() {
              _containerHover = false;
            });
          }
        },
        child: GestureDetector(
          onTap: () {
            if (clicked) {
              widget.onClick(widget.episode);
            } else {
              episodeController.changeSelected(widget.episode);
            }
          },
          child: clicked
              ? Container(
                  width: 600,
                  height: 190,
                  color: clickedColor,
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    contentRow,
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.episodeContent.poster),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: widget.currentEpisode == widget.episode
                              ? Container()
                              : AnimatedScale(
                                  duration: _animation,
                                  scale: _containerHover ? 1.25 : 1,
                                  child: AnimatedOpacity(
                                    duration: _animation,
                                    opacity: _containerHover ? 1 : 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(30),
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
                                  ),
                                ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 330,
                          child: Text(
                            widget.episodeContent.overview,
                            style: headline2,
                          ),
                        )
                      ],
                    )
                  ]),
                )
              : Container(
                  width: 600,
                  height: 70,
                  color: _containerHover ? highlightColor : backgroundColor,
                  child: contentRow),
        ));
  }
}
