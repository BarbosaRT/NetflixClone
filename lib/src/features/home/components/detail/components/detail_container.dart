import 'package:flutter/material.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailContainer extends StatefulWidget {
  final ContentModel content;
  final int index;
  const DetailContainer(
      {super.key, required this.content, required this.index});

  @override
  State<DetailContainer> createState() => _DetailContainerState();
}

class _DetailContainerState extends State<DetailContainer> {
  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();

    final headline = AppFonts().headline4;
    final headline2 = AppFonts().headline6;
    final headline3 =
        AppFonts().labelIntermedium.copyWith(color: Colors.grey.shade300);
    final onColor = Colors.grey.shade800;

    return Container(
        width: 750,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: onColor,
        ),
        child: Stack(children: [
          Container(
            width: 750,
            height: 139,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
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
                const SizedBox(
                  width: 20,
                ),
                Container(
                    width: 160,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                        Image.asset(widget.content.poster, fit: BoxFit.cover)),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 450,
                      child: Row(
                        children: [
                          Text(
                            widget.content.title,
                            style: headline2,
                          ),
                          const Spacer(),
                          Text(
                            '22min',
                            style: headline2,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: 450,
                        height: 65,
                        child: Text(widget.content.overview, style: headline3)),
                  ],
                )
              ],
            ),
          ),
        ]));
  }
}
