import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';

class DetailContent extends StatefulWidget {
  final ContentModel content;
  final double? containerWidth;
  const DetailContent({super.key, required this.content, this.containerWidth});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  final ValueNotifier<bool> _isHover = ValueNotifier(false);
  ValueNotifier<bool> added = ValueNotifier(false);

  void onExit() {
    _isHover.value = false;
  }

  void onHover() {
    _isHover.value = true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.containerColor3;

    // Use passed containerWidth or calculate responsively
    final containerWidth = widget.containerWidth ??
        (width < 600
            ? 200.0
            : width < 1200
                ? 220.0
                : 236.0);

    // Calculate height proportionally to container width
    final baseContainerHeight =
        containerWidth * 1.5 + 20; // Maintain aspect ratio
    final bottomPadding =
        (containerWidth * 0.08).clamp(15.0, 25.0); // Bottom padding
    final containerHeight = baseContainerHeight + bottomPadding;
    final imageHeight = containerWidth * 0.55; // Proportional image height

    final totalWidth = containerWidth + 64; // Adding some padding space

    // Responsive font sizes based on container width
    final baseFontSize = (containerWidth / 236.0).clamp(0.8, 1.2);
    final headline = AppFonts().headline6.copyWith(
          fontSize: (14.0 * baseFontSize).clamp(11.0, 16.0),
        );

    final headline2 = AppFonts().headline8.copyWith(
          color: const Color.fromRGBO(190, 190, 190, 1),
          fontSize: (12.0 * baseFontSize).clamp(9.0, 14.0),
        );

    // Responsive overview length based on container width
    int overviewLength = (containerWidth * 0.65).round().clamp(100, 180);

    String overview = widget.content.overview;
    if (overview.length > overviewLength) {
      overview = '${overview.substring(0, overviewLength)}...';
    }

    bool isOnline = widget.content.isOnline;
    String thumbnail = widget.content.poster;

    dynamic image = isOnline ? NetworkImage(thumbnail) : AssetImage(thumbnail);

    return SizedBox(
      width: totalWidth,
      height: containerHeight,
      child: Stack(
        children: [
          Container(
            width: containerWidth,
            height: baseContainerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
            ),
          ),
          Container(
            width: containerWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _isHover,
            builder: (context, bool value, child) {
              final playIconSize = (containerWidth * 0.21).clamp(30.0, 55.0);

              return Container(
                width: containerWidth,
                height: imageHeight + 10,
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: value ? 1 : 0,
                  child: Icon(Icons.play_arrow,
                      size: playIconSize, color: Colors.white),
                ),
              );
            },
          ),
          //
          // Details
          //
          Positioned(
            left: containerWidth * 0.4,
            child: Container(
              width: containerWidth * 0.6,
              height: imageHeight + 10,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0),
                    ]),
              ),
              child: Padding(
                padding:
                    EdgeInsets.all((containerWidth * 0.034).clamp(5.0, 10.0)),
                child: Text(
                  widget.content.detail,
                  style: headline2.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          //
          // Info
          //
          Positioned(
            top: imageHeight + 20,
            child: Row(
              children: [
                Container(
                  width: containerWidth - 30,
                  margin: EdgeInsets.only(
                      left: (containerWidth * 0.06).clamp(8, 18)),
                  child: Column(
                    children: [
                      SizedBox(
                        width: containerWidth - 30,
                        child: Text(
                          '61% Relevante',
                          style: headline.copyWith(color: Colors.green),
                        ),
                      ),
                      SizedBox(
                        height: (containerWidth * 0.02).clamp(3, 7),
                      ),
                      SizedBox(
                        width: containerWidth - 30,
                        child: Row(
                          children: [
                            Image.asset(
                              AppConsts.classifications[widget.content.age] ??
                                  'assets/images/classifications/L.png',
                              width: (containerWidth * 0.13).clamp(20, 35),
                              height: (containerWidth * 0.13).clamp(20, 35),
                            ),
                            Text(
                              ' 2020',
                              style: headline,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: imageHeight + 90,
            left: (containerWidth * 0.07).clamp(10, 20),
            child: SizedBox(
              width: containerWidth - (containerWidth * 0.14).clamp(20, 40),
              child: Text(
                overview,
                style: headline2,
              ),
            ),
          ),
          //
          // Lista
          //
          Positioned(
            top: imageHeight - 40,
            // Position from right edge
            right: (containerWidth * 0.05).clamp(8.0, 15.0) - 40,
            child: ContentButton(
              onClick: () {
                added.value = !added.value;
              },
              text: ValueListenableBuilder(
                valueListenable: added,
                builder: (BuildContext context, bool value, child) {
                  final buttonTextStyle = headline.copyWith(
                    color: Colors.black,
                    fontSize: (headline.fontSize! * 0.85).clamp(9.0, 13.0),
                  );
                  return Text(
                    value
                        ? 'Remover da Minha lista'
                        : 'Adicionar à Minha lista',
                    textAlign: TextAlign.center,
                    style: buttonTextStyle,
                  );
                },
              ),
              icon: ValueListenableBuilder(
                valueListenable: added,
                builder: (BuildContext context, bool value, child) {
                  final iconSize = (containerWidth * 0.11).clamp(18.0, 28.0);
                  return Icon(
                    value ? Icons.done : Icons.add,
                    size: iconSize,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          HoverWidget(
            useNotification: false,
            delayOut: Duration.zero,
            fadeDuration: Duration.zero,
            maxWidth: containerWidth,
            maxHeight: containerHeight,
            rightPadding: containerWidth,
            detectChildArea: false,
            onExit: onExit,
            onHover: onHover,
            icon: SizedBox(
              width: containerWidth,
              height: containerHeight,
            ),
          )
        ],
      ),
    );
  }
}
