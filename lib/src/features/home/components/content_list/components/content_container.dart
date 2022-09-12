import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';
import 'package:netflix/src/features/home/components/content_list/components/like_button.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ContentContainer extends StatefulWidget {
  final ContentContainerAnchor anchor;
  final int localIndex;
  final int index;
  final Function(int) onHover;
  final Function()? onExit;
  const ContentContainer({
    super.key,
    required this.anchor,
    required this.localIndex,
    required this.index,
    required this.onHover,
    this.onExit,
  });

  @override
  State<ContentContainer> createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer> {
  bool isHover = false;
  bool hover = false;

  int recomentationValue = 90;
  int temps = 10;

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeInOut;
  static const delay = Duration(milliseconds: 400);
  static const double realWidth = 325;
  static const double width = 245;
  static const double wDifference = 60;
  static const double height = 132;
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

  void onExit() {
    if (widget.onExit != null) {
      widget.onExit!();
    }
    isHover = false;
    if (mounted) {
      setState(() {
        hover = false;
      });
    }
  }

  void onHover() {
    isHover = true;
    widget.onHover(widget.localIndex);
    Future.delayed(delay).then((value) {
      if (!isHover) {
        return;
      }
      if (mounted) {
        setState(() {
          hover = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline = AppFonts().headline7;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.loginTextFieldColor;
    // const image =
    //     'https://occ-0-2635-778.1.nflxso.net/dnm/api/v6/0DW6CdE4gYtYx8iy3aj8gs9WtXE/AAAABa7drB88__T4L1EqN-1m1xYIf2R7JjPHpzm2A8iMUkj0DFFnhw9HRbYhyeHFTxREgaaZf11Jv5q6QaONhc9oVfoGXypKdNPbEeBLRCMQQbxceC3uURs.jpg?r=0af';

    const decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(border)),
      color: Colors.red,
      // image: DecorationImage(
      //   image: NetworkImage(image),
      //   fit: BoxFit.cover,
      // ),
    );

    const movieDecoraion = BoxDecoration(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(hoverBorder),
        topLeft: Radius.circular(hoverBorder),
      ),
      color: Colors.blue,
      // image: DecorationImage(
      //   image: NetworkImage(image),
      //   fit: BoxFit.cover,
      // ),
    );

    const infoContainer = BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(hoverBorder),
        bottomLeft: Radius.circular(hoverBorder),
      ),
    );

    return AnimatedContainer(
      curve: curve,
      duration: duration,
      //
      height: hover ? height * factor + infoHeight : height * factor,
      //
      width: hover ? realWidth * factor : width,
      //
      transform: Matrix4.translation(
        vector.Vector3(
            hover
                ? getValueFromAnchor(-wDifference,
                    -padding / 2 - wDifference + 5, -padding - wDifference + 15)
                : 0,
            hover ? 0 : 120,
            0),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          //
          // Content Container
          //
          AnimatedContainer(
              curve: curve,
              duration: duration,
              margin:
                  hover ? const EdgeInsets.only(right: 60) : EdgeInsets.zero,
              width: hover ? width * factor : width,
              height: hover ? height * factor : height,
              decoration: hover ? movieDecoraion : decoration,
              child: Center(
                child: Text(
                  widget.index.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )),
          //
          // Info Container
          //
          AnimatedContainer(
              margin: EdgeInsets.only(
                top: hover ? height * factor - 50 : height,
              ),
              curve: curve,
              duration: duration,
              height: hover ? infoHeight + 70 : 0,
              width: hover ? realWidth * factor : width,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    //
                    // Background
                    //
                    AnimatedContainer(
                      duration: duration,
                      margin: EdgeInsets.only(
                          left: hover ? wDifference : 0, top: 50),
                      width: width * factor,
                      height: infoHeight,
                      decoration: infoContainer.copyWith(
                        color: backgroundColor,
                      ),
                    ),
                    //
                    // Icons
                    //
                    Positioned(
                      child: SizedBox(
                        width: realWidth * factor,
                        height: 200,
                        child: Stack(
                          children: const [
                            Positioned(
                              left: 15 + wDifference,
                              top: 70,
                              child: Icon(
                                Icons.play_circle,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                            //
                            Positioned(
                              top: 2,
                              left: 17,
                              child: ContentButton(
                                text: 'Adicionar à Minha Lista',
                                icon: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 2,
                              left: 18,
                              child: LikeButton(),
                            ),
                            Positioned(
                              top: 2,
                              left: 260,
                              child: ContentButton(
                                text: 'Mais Informações',
                                icon: Icon(
                                  Icons.expand_more_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                    // Infos
                    //
                    Positioned(
                      left: 15 + wDifference,
                      top: 130,
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
                    //
                    // Tags
                    //
                    Positioned(
                      left: 15 + wDifference,
                      top: 170,
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
                  ],
                ),
              )),
          //
          // Mouse Region
          //
          Positioned(
            left: wDifference,
            child: MouseRegion(
              opaque: false,
              onEnter: (event) {
                onHover();
              },
              onHover: (v) {
                onHover();
              },
              //
              //
              onExit: (event) {
                onExit();
              },
              child: Container(
                  //
                  height: hover
                      ? height * factor + infoHeight
                      : height * factor - 60,
                  //
                  width: hover ? width * factor : width,
                  //
                  color: Colors.yellow.withOpacity(0.0)),
            ),
          ),
        ],
      ),
    );
  }
}
