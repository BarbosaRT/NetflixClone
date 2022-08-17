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
  final double elevation;
  const MovieContainer(
      {super.key,
      required this.anchor,
      required this.index,
      this.elevation = 0});

  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  bool isHover = false;
  bool hover = false;

  int recomentationValue = 0;
  int temps = 0;
  @override
  void initState() {
    final random = Random(69 * widget.index * 2);
    recomentationValue = random.nextInt(20) + 80;
    temps = random.nextInt(5) + 5;
    super.initState();
  }

  //TODO: Melhorar UI do widget e fazer ele passar, alem dos efeitinhos é claro
  //TODO: Centralizar o widget e fazer ele para o canto esquerdo a cada 5 widgets
  //TODO: Terminar Barra de cima

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeIn;
  static const delay = Duration(milliseconds: 400);
  static const double width = 260;
  static const double height = 140;
  static const double factor = 1.45;
  static const double infoHeight = width * factor - height * factor;
  static const double padding = 100;

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

  void onEnter() {
    //final movieProvider = MovieProvider.of(context);
    //movieProvider!.index = widget.index;
    final controller = context.watch<CurrentMovie>();
    controller.changeCurrent(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<MovieListController>();
    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 17,
            ));

    const backgroundColor = Color.fromRGBO(40, 40, 40, 1);

    if (isHover) {
      controller.changeCurrent(widget.index);
    }

    return AnimatedContainer(
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
          controller.changeCurrent(widget.index);
        },
        //
        //
        onHover: (v) {
          isHover = true;
          Future.delayed(delay).then((value) {
            if (!isHover) {
              return;
            }
            setState(() {
              hover = true;
            });
          });
        },
        //
        //
        onExit: (event) {
          isHover = false;
          controller.disableChange();
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
                color: Colors.red,
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
                color: backgroundColor,
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
                      // Tags
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
  }
}
