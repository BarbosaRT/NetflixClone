import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/content_list_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

enum ContentContainerAnchor { left, center, right }

class ContentContainer extends StatefulWidget {
  final ContentContainerAnchor anchor;
  final int index;
  final String posterPath;
  const ContentContainer({
    super.key,
    required this.anchor,
    required this.index,
    required this.posterPath,
  });

  @override
  State<ContentContainer> createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer> {
  bool isHover = false;
  bool hover = false;
  var random = Random(69);
  int recomentationValue = 0;
  int temps = 0;

  @override
  void initState() {
    super.initState();
    random = Random(69 * widget.index * 2);
    recomentationValue = random.nextInt(20) + 80;
    temps = random.nextInt(5) + 5;
  }

  //TODO: Colocar as fontes, colocar os icones, e as cores
  //TODO: Melhorar MouseRegion da lista e fazer ela mostrar o lado esquerdo
  //TODO: Melhorar UI do widget e fazer ele passar, alem dos efeitinhos

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeInOut;
  static const delay = Duration(milliseconds: 400);
  static const double width = 250;
  static const double height = 140;
  static const double factor = 1.5;
  static const double padding = 140;

  static const double infoHeight = width * factor - height * factor;
  static const double border = 5;
  static const double hoverBorder = 10;

  double getValueFromAnchor(double left, double center, double right) {
    switch (widget.anchor) {
      case ContentContainerAnchor.left:
        return left;
      case ContentContainerAnchor.center:
        return center;
      case ContentContainerAnchor.right:
        return right;
    }
  }

  void onHover() {
    isHover = true;
    final controller = Modular.get<ContentListController>();
    controller.changeCurrent(widget.index, 0);
    Future.delayed(delay).then((value) {
      if (!isHover) {
        return;
      }
      setState(() {
        hover = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline = AppFonts().headline7;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(border)),
      color: Colors.red,
      image: DecorationImage(
        image:
            NetworkImage('https://image.tmdb.org/t/p/w400${widget.posterPath}'),
        fit: BoxFit.cover,
      ),
    );

    final movieDecoraion = BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(hoverBorder),
        topLeft: Radius.circular(hoverBorder),
      ),
      color: Colors.blue,
      image: DecorationImage(
        image:
            NetworkImage('https://image.tmdb.org/t/p/w500${widget.posterPath}'),
        fit: BoxFit.cover,
      ),
    );

    const infoContainer = BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(hoverBorder),
        bottomLeft: Radius.circular(hoverBorder),
      ),
    );

    final output = AnimatedContainer(
      curve: curve,
      duration: duration,
      //
      height: hover ? height * factor + infoHeight : height * factor - 60,
      //
      width: hover ? width * factor : width,
      //
      transform: Matrix4.translation(
        vector.Vector3(
            hover ? getValueFromAnchor(0, -padding / 2, -padding + 15) : 0,
            hover ? 0 : 120,
            0),
      ),
      child: MouseRegion(
        onEnter: (event) {
          onHover();
        },
        //
        //
        onHover: (v) {
          onHover();
        },
        //
        //
        onExit: (event) {
          isHover = false;
          setState(() {
            hover = false;
          });
        },
        //
        //
        child: Stack(
          children: [
            AnimatedContainer(
              curve: curve,
              duration: duration,
              width: hover ? width * factor : width,
              height: hover ? height * factor : height,
              decoration: hover ? movieDecoraion : decoration,
            ),
            AnimatedContainer(
                margin: EdgeInsets.only(
                  top: hover ? height * factor : height,
                ),
                curve: curve,
                duration: duration,
                height: hover ? infoHeight : 0,
                width: hover ? width * factor : width,
                decoration: hover
                    ? infoContainer.copyWith(
                        color: backgroundColor,
                      )
                    : BoxDecoration(
                        color: backgroundColor,
                      ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Icons
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: width * factor,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_circle,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                //
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                //
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: width * 0.7,
                                ),
                                //
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.expand_more_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Infos
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: width * factor,
                            child: Row(
                              children: [
                                Text(
                                  '$recomentationValue% relevante',
                                  style: headline.copyWith(color: Colors.green),
                                ),
                                const SizedBox(width: 8),
                                //
                                Image.asset(
                                  'assets/images/L.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$temps temporadas',
                                  style: headline,
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  height: 25,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      'HD',
                                      style: headline.copyWith(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      // Tags
                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: width * factor,
                            child: Row(
                              children: [
                                Text(
                                  'Besteirol',
                                  style: headline,
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.circle,
                                  size: 5,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                //
                                //
                                Text(
                                  'Comedia',
                                  style: headline,
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.circle,
                                  size: 5,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                //
                                //
                                Text(
                                  'Muito Sexo',
                                  style: headline,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
    return output;
  }
}
