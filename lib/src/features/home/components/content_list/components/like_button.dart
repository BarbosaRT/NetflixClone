import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/core/colors/color_controller.dart';
import 'package:oldflix/core/fonts/app_fonts.dart';
import 'package:oldflix/src/features/home/components/content_list/components/content_button.dart';
import 'package:oldflix/src/features/splash/components/icon_painter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

enum SelectedButton { deslike, like, love, none }

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  static const Duration delay = Duration(milliseconds: 200);
  final ValueNotifier<bool> _loveSelected = ValueNotifier(false);
  final ValueNotifier<bool> _likeSelected = ValueNotifier(false);
  final ValueNotifier<bool> _deslikeSelected = ValueNotifier(false);
  SelectedButton _selectedButton = SelectedButton.none;
  bool hover = false;

  void onHover() {
    if (mounted) {
      setState(() {
        hover = true;
      });
    }
  }

  void onExit() {
    if (mounted) {
      setState(() {
        hover = false;
      });
    }
  }

  Widget getButton(Path path, vector.Vector3 vetor, Color color) {
    return Transform(
      transform: Matrix4.translation(vetor),
      alignment: Alignment.center,
      child: CustomPaint(
        painter: IconPainter(
          path: path,
          color: color,
        ),
        child: Container(
          height: 40,
          width: 40,
          color: Colors.transparent,
        ),
      ),
    );
  }

  // Widget withValues(alpha: Widget widget, EdgeInsets padding) {
  //   return AnimatedOpacity(
  //     opacity: hover ? 1 : 0,
  //     duration: delay,
  //     child: AnimatedContainer(
  //       margin: hover ? padding : EdgeInsets.zero,
  //       duration: delay,
  //       width: 40,
  //       height: 40,
  //       child: widget,
  //     ),
  //   );
  // }

  Widget buttonBuilder(
      Widget widgetOn, Widget widgetOff, SelectedButton selection) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        children: [
          AnimatedContainer(
              duration: delay,
              width: 40,
              height: 40,
              curve: Curves.easeInExpo,
              transform: Matrix4.translation(
                vector.Vector3(0, _selectedButton == selection ? 7 : 0, 0),
              ),
              child: AnimatedContainer(
                duration: delay,
                curve: Curves.easeOutExpo,
                transform: Matrix4.translation(
                  vector.Vector3(0, _selectedButton == selection ? -7 : 0, 0),
                ),
                child: _selectedButton == selection ? widgetOn : Container(),
              )),
          _selectedButton == selection ? Container() : widgetOff
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();
    final hoverOffColor = colorController.currentScheme.darkBackgroundColor;
    final backgroundColor = colorController.currentScheme.likeButtonColor;

    final headline6 = AppFonts().headline6;

    final likeIconOn = parseSvgPathData(
        'M 1 22 L 1 12 q 7 0 6 -11 Q 13 1 13 6 L 13 10 L 14 10 C 24 9.6 24 24 12 24 L 1 22');
    final likeIconOff = parseSvgPathData(
      'M 0 18 L 0 10 Q 8 10 6 0 Q 10 0 10 4 L 10 8 L 12 8 C 20 8 20 20 10 20 L 0 18',
    );

    final deslikeMatrix = Matrix4.translation(vector.Vector3(0, 37, 0));

    final loveWidget = ValueListenableBuilder(
        valueListenable: _loveSelected,
        builder: (context, bool value, child) {
          return ContentButton(
            hoverActive: false,
            onClick: () {
              setState(() {
                _selectedButton = _selectedButton == SelectedButton.love
                    ? SelectedButton.none
                    : SelectedButton.love;
              });
            },
            onHover: () {
              _loveSelected.value = true;
            },
            onExit: () {
              _loveSelected.value = false;
            },
            icon: buttonBuilder(
                Stack(
                  children: [
                    getButton(
                        likeIconOff, vector.Vector3(14, 6, 0), Colors.grey),
                    // like in front
                    getButton(likeIconOn, vector.Vector3(8, 5, 0),
                        hover ? backgroundColor : hoverOffColor),
                    getButton(
                        likeIconOff, vector.Vector3(10, 8, 0), Colors.white),
                  ],
                ),
                Stack(
                  children: [
                    getButton(
                        likeIconOn, vector.Vector3(12, 3, 0), Colors.white),
                    getButton(likeIconOff, vector.Vector3(14, 6, 0),
                        hover ? backgroundColor : hoverOffColor),
                    // like in front
                    getButton(
                        likeIconOn, vector.Vector3(8, 5, 0), Colors.white),
                    getButton(likeIconOff, vector.Vector3(10, 8, 0),
                        hover ? backgroundColor : hoverOffColor),
                  ],
                ),
                SelectedButton.love),
            text: Text(
              _selectedButton == SelectedButton.love ? 'Avaliado' : 'Amei!',
              textAlign: TextAlign.center,
              style: headline6.copyWith(color: Colors.black),
            ),
            circleColor: hover ? Colors.transparent : Colors.grey,
            opacity: value ? 0.1 : 0,
          );
        });

    //
    final deslikeWidget = ValueListenableBuilder(
        valueListenable: _deslikeSelected,
        builder: (context, bool value, child) {
          return ContentButton(
            hoverActive: false,
            onClick: () {
              setState(() {
                _selectedButton = _selectedButton == SelectedButton.deslike
                    ? SelectedButton.none
                    : SelectedButton.deslike;
              });
            },
            onHover: () {
              _deslikeSelected.value = true;
            },
            onExit: () {
              _deslikeSelected.value = false;
            },
            icon: buttonBuilder(
                Transform(
                  transform: deslikeMatrix,
                  child: Transform(
                    transform: Matrix4.rotationY(math.pi),
                    child: Transform(
                        transform: Matrix4.rotationZ(math.pi),
                        child: getButton(likeIconOff, vector.Vector3(10, 8, 0),
                            Colors.white)),
                  ),
                ),
                Stack(
                  children: [
                    Transform(
                      transform: deslikeMatrix,
                      child: Transform(
                        transform: Matrix4.rotationY(math.pi),
                        child: Transform(
                          transform: Matrix4.rotationZ(math.pi),
                          child: getButton(likeIconOn, vector.Vector3(8, 5, 0),
                              Colors.white),
                        ),
                      ),
                    ),
                    Transform(
                      transform: deslikeMatrix,
                      child: Transform(
                        transform: Matrix4.rotationY(math.pi),
                        child: Transform(
                          transform: Matrix4.rotationZ(math.pi),
                          child: getButton(likeIconOff,
                              vector.Vector3(10, 8, 0), backgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SelectedButton.deslike),
            text: Text(
              _selectedButton == SelectedButton.deslike
                  ? 'Avaliado'
                  : 'Não é para mim',
              textAlign: TextAlign.center,
              style: headline6.copyWith(color: Colors.black),
            ),
            circleColor: hover ? Colors.transparent : Colors.grey,
            opacity: value ? 0.1 : 0,
          );
        });

    //
    final likeWidget = ValueListenableBuilder(
        valueListenable: _likeSelected,
        builder: (context, bool value, child) {
          return ContentButton(
            hoverActive: false,
            onClick: () {
              setState(() {
                _selectedButton = _selectedButton == SelectedButton.like
                    ? SelectedButton.none
                    : SelectedButton.like;
              });
            },
            onHover: () {
              _likeSelected.value = true;
            },
            onExit: () {
              _likeSelected.value = false;
            },
            icon: buttonBuilder(
                getButton(likeIconOff, vector.Vector3(10, 8, 0), Colors.white),
                Stack(
                  children: [
                    getButton(
                        likeIconOn, vector.Vector3(8, 5, 0), Colors.white),
                    getButton(likeIconOff, vector.Vector3(10, 8, 0),
                        hover ? backgroundColor : hoverOffColor),
                  ],
                ),
                SelectedButton.like),
            text: Text(
              _selectedButton == SelectedButton.like ? 'Avaliado' : 'Gostei',
              textAlign: TextAlign.center,
              style: headline6.copyWith(color: Colors.black),
            ),
            circleColor: hover ? Colors.transparent : Colors.grey,
            opacity: value ? 0.1 : 0,
          );
        });

    return AnimatedContainer(
        height: 120,
        duration: delay,
        margin: EdgeInsets.only(left: hover ? 0 : 45),
        child: Stack(children: [
          // Background
          AnimatedContainer(
            width: hover ? 140 : 50,
            height: 50,
            margin: const EdgeInsets.only(left: 100, top: 65),
            duration: delay,
            decoration: hover
                ? BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: backgroundColor,
                  )
                : const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
          ),
          //
          // DeslikeButton
          //
          AnimatedOpacity(
            duration: delay,
            opacity: _selectedButton == SelectedButton.deslike || hover ? 1 : 0,
            child: AnimatedContainer(
              duration: delay,
              margin:
                  hover ? const EdgeInsets.only(right: 45) : EdgeInsets.zero,
              child: deslikeWidget,
            ),
          ),
          //
          // LoveButton
          //
          AnimatedOpacity(
            duration: delay,
            opacity: _selectedButton == SelectedButton.love || hover ? 1 : 0,
            child: AnimatedContainer(
              duration: delay,
              margin: hover ? const EdgeInsets.only(left: 90) : EdgeInsets.zero,
              child: loveWidget,
            ),
          ),
          //
          // LikeButton
          //
          AnimatedOpacity(
            duration: delay,
            opacity: _selectedButton == SelectedButton.like ||
                    _selectedButton == SelectedButton.none ||
                    hover
                ? 1
                : 0,
            child: AnimatedContainer(
              margin: hover ? const EdgeInsets.only(left: 45) : EdgeInsets.zero,
              duration: delay,
              child: likeWidget,
            ),
          ),
          //
          // MouseRegion
          //
          Positioned(
            left: 100,
            top: 65,
            child: MouseRegion(
              opaque: false,
              onHover: (event) {
                onHover();
              },
              onExit: (event) {
                onExit();
              },
              child: AnimatedContainer(
                duration: delay,
                width: hover ? 140 : 50,
                height: 50,
              ),
            ),
          ),
        ]));
  }
}
