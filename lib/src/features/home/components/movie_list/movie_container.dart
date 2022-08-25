import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_list_controller.dart';

import 'package:vector_math/vector_math_64.dart' as vector;

enum MovieContainerAnchor { left, center, right }

class MovieContainer extends StatefulWidget {
  final MovieContainerAnchor anchor;
  final int index;
  const MovieContainer({super.key, required this.anchor, required this.index});

  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  bool isHover = false;
  bool hover = false;

  var random = Random(69);
  int recomentationValue = 0;
  int temps = 0;
  Color? color;

  @override
  void initState() {
    super.initState();
    random = Random(69 * widget.index * 2);
    color = Color.fromRGBO(
      min(255, 7 * widget.index),
      min(255, 5 * widget.index),
      min(255, 10 * widget.index),
      1,
    );
    recomentationValue = random.nextInt(20) + 80;
    temps = random.nextInt(5) + 5;
  }

  //TODO: Refatorar, colocar os icones, e as cores
  //TODO: Melhorar UI do widget e fazer ele passar, alem dos efeitinhos é claro

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeIn;
  static const delay = Duration(milliseconds: 400);
  static const double width = 260;
  static const double height = 140;
  static const double factor = 1.45;
  static const double padding = 100;

  static const double infoHeight = width * factor - height * factor;
  static const double border = 5;
  static const double hoverBorder = 10;

  double getValueFromAnchor(double left, double center, double right) {
    switch (widget.anchor) {
      case MovieContainerAnchor.left:
        return left;
      case MovieContainerAnchor.center:
        return center;
      case MovieContainerAnchor.right:
        return right;
    }
  }

  void onHover() {
    isHover = true;
    final controller = Modular.get<MovieListController>();
    controller.changeCurrent(widget.index);
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
    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 17,
            ));

    const backgroundColor = Color.fromRGBO(40, 40, 40, 1);
    const decoration =
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(border)));

    const movieDecoraion = BoxDecoration(
        borderRadius: BorderRadius.only(
      topRight: Radius.circular(hoverBorder),
      topLeft: Radius.circular(hoverBorder),
    ));
    const infoContainer = BoxDecoration(
        borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(hoverBorder),
      bottomLeft: Radius.circular(hoverBorder),
    ));

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
            hover ? getValueFromAnchor(0, -padding / 2, -padding - 20) : 0,
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
                decoration: hover
                    ? movieDecoraion.copyWith(
                        color: color,
                      )
                    : decoration.copyWith(
                        color: color,
                      ),
                child: Center(
                    child: Text(
                  widget.index.toString(),
                  style: headline6,
                ))),
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
                    : const BoxDecoration(
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
                              children: const [
                                Icon(
                                  Icons.play_circle,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                //
                                Icon(
                                  Icons.add_circle,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                //
                                Icon(
                                  Icons.recommend,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 180,
                                ),
                                //
                                Icon(
                                  Icons.expand_more,
                                  size: 40,
                                  color: Colors.white,
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
                                  style:
                                      headline6.copyWith(color: Colors.green),
                                ),
                                const SizedBox(width: 10),
                                //
                                Image.asset(
                                  'assets/images/L.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$temps temporadas',
                                  style: headline6,
                                ),
                                const SizedBox(width: 10),
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
                                      style: headline6.copyWith(fontSize: 10),
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
                                  style: headline6,
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
                                  style: headline6,
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
                                  style: headline6,
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
