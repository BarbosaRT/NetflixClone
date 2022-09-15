import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
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

  bool isHover = false;
  bool hover = false;
  ValueNotifier<bool> added = ValueNotifier(false);

  ContentModel content = ContentModel.fromJson("""{
            "title": "Breaking Bad",
            "backdrop": "assets/data/breaking_bad_backdrop.jpg",
            "poster": "assets/data/breaking_bad_poster.jpg",
            "rating": 98,
            "trailer": "assets/data/breaking_bad_trailer.mp4",
            "tags": [
                "Violentos",
                "Realistas",
                "Suspense"
            ],
            "age": 18,
            "detail": "5 temporadas",
            "logo": "assets/data/breaking_bad_logo.png",
            "overview": "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime."
            }""");

  @override
  void initState() {
    super.initState();
    final controller = Modular.get<ContentController>();
    controller.addListener(() {
      if (!controller.loading) {
        setState(() {
          content = controller.getContent(widget.index);
        });
      }
    });
  }

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
    final headline6 = AppFonts().headline6;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.containerColor;
    final image = content.poster;

    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(border)),
      color: Colors.red,
      image: DecorationImage(
        image: AssetImage(image),
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
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
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
        alignment: AlignmentDirectional.topCenter,
        children: [
          //
          // Content Container
          //
          AnimatedContainer(
              curve: curve,
              duration: duration,
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
          AnimatedPositioned(
            curve: curve,
            duration: duration,
            top: hover ? height * factor - 50 : height,
            child: AnimatedOpacity(
              duration: duration,
              curve: curve,
              opacity: hover ? 1 : 0,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  AnimatedContainer(
                    duration: duration,
                    margin: EdgeInsets.only(top: hover ? 50 : 0),
                    width: hover ? width * factor : width,
                    height: infoHeight,
                    decoration: infoContainer.copyWith(
                      color: backgroundColor,
                    ),
                  ),
                  //
                  // Icons
                  //
                  Positioned(
                    child: AnimatedContainer(
                      duration: duration,
                      curve: curve,
                      margin: EdgeInsets.only(
                          right: hover ? 0 : width - wDifference * 2),
                      width: hover ? realWidth * factor : realWidth,
                      height: 200,
                      child: Stack(
                        children: [
                          const Positioned(
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
                                onClick: () {
                                  added.value = !added.value;
                                },
                                text: ValueListenableBuilder(
                                  valueListenable: added,
                                  builder: (BuildContext context, bool value,
                                      child) {
                                    return Text(
                                      value
                                          ? 'Remover da lista'
                                          : 'Adicionar à lista',
                                      textAlign: TextAlign.center,
                                      style: headline6.copyWith(
                                          color: Colors.black),
                                    );
                                  },
                                ),
                                icon: ValueListenableBuilder(
                                  valueListenable: added,
                                  builder: (BuildContext context, bool value,
                                      child) {
                                    return Icon(
                                      value ? Icons.done : Icons.add,
                                      size: 25,
                                      color: Colors.white,
                                    );
                                  },
                                )),
                          ),

                          const Positioned(
                            top: 2,
                            left: 18,
                            child: LikeButton(),
                          ),
                          Positioned(
                            top: 2,
                            left: 260,
                            child: ContentButton(
                              text: Text(
                                'Mais Informações',
                                textAlign: TextAlign.center,
                                style: headline6.copyWith(color: Colors.black),
                              ),
                              icon: const Icon(
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
                            '${content.rating}% relevante',
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
                            content.detail,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                          for (int i = 0; i <= content.tags.length - 2; i++)
                            Row(
                              children: [
                                Text(
                                  content.tags[i],
                                  style: headline,
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.circle,
                                  size: 5,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          //
                          //
                          Text(
                            content.tags[content.tags.length - 1],
                            style: headline,
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
          // Mouse Region
          //
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            left: hover ? wDifference : 0,
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
                  color: Colors.yellow.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
