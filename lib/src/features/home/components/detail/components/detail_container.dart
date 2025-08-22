import 'package:flutter/material.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/player/player_page.dart';

class DetailContainer extends StatefulWidget {
  final ContentModel content;
  final int index;
  const DetailContainer(
      {super.key, required this.content, required this.index});

  @override
  State<DetailContainer> createState() => _DetailContainerState();
}

class _DetailContainerState extends State<DetailContainer> {
  final ValueNotifier<bool> _isHover = ValueNotifier(false);

  void onExit() {
    _isHover.value = false;
  }

  void onHover() {
    _isHover.value = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final colorController = Modular.get<ColorController>();

    final headline = AppFonts().headline4;
    final headline2 = AppFonts().headline6;
    final headline3 =
        AppFonts().labelIntermedium.copyWith(color: Colors.grey.shade300);
    final onColor = Colors.grey.shade800;

    final episodeContent = ContentModel.fromMap(widget.content
        .episodes![widget.content.episodes!.keys.toList()[widget.index]]);

    // Calculate responsive dimensions
    final rightMargin = width > 1200 ? 600.0 : width * 0.5;
    final containerWidth = width - rightMargin;
    final imageWidth = (containerWidth * 0.25).clamp(120.0, 200.0);
    final imageHeight = (imageWidth * 9 / 16).clamp(60.0, 120.0);

    return Container(
      color: Colors.red,
      child: HoverWidget(
        useNotification: false,
        delayOut: Duration.zero,
        fadeDuration: Duration.zero,
        maxWidth: width - rightMargin,
        maxHeight: 140,
        rightPadding: width - rightMargin,
        detectChildArea: false,
        onExit: onExit,
        onHover: onHover,
        icon: Container(
          width: containerWidth,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: onColor,
          ),
          child: Stack(
            children: [
              Container(
                width: containerWidth,
                height: 139,
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: (containerWidth * 0.05).clamp(20.0, 40.0)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.index == 0
                      ? onColor
                      : colorController.currentScheme.darkBackgroundColor,
                ),
                child: Row(
                  children: [
                    Text(
                      '${widget.index + 1}',
                      style: headline,
                    ),
                    SizedBox(
                      width: (containerWidth * 0.02).clamp(10.0, 25.0),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(episodeContent.poster,
                              fit: BoxFit.cover),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isHover,
                          builder: (context, bool value, child) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: value ? 1 : 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  var playerNotifier =
                                      Modular.get<PlayerNotifier>();
                                  playerNotifier.playerModel =
                                      PlayerModel(widget.content, widget.index);
                                  Modular.to.pushNamed('/video');
                                },
                                icon: Icon(Icons.play_arrow,
                                    size: (imageWidth * 0.3).clamp(30.0, 50.0),
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: (containerWidth * 0.02).clamp(10.0, 25.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  episodeContent.title,
                                  style: headline2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '22min',
                                style: headline2,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 65,
                            child: Text(
                              episodeContent.overview,
                              style: headline3,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
