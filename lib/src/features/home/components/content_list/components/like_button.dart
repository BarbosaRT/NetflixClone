import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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

  Widget withOpacity(Widget widget, EdgeInsets padding) {
    return AnimatedOpacity(
      opacity: hover ? 1 : 0,
      duration: delay,
      child: AnimatedContainer(
        margin: hover ? padding : EdgeInsets.zero,
        duration: delay,
        width: 40,
        height: 40,
        child: widget,
      ),
    );
  }

  Widget buttonBuilder(String on, String off, SelectedButton selection) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        children: [
          AnimatedContainer(
              duration: delay,
              width: 40,
              height: 40,
              curve: Curves.easeInQuint,
              transform: Matrix4.translation(
                vector.Vector3(0, _selectedButton == selection ? 7 : 0, 0),
              ),
              child: AnimatedContainer(
                duration: delay,
                curve: Curves.easeOutQuint,
                transform: Matrix4.translation(
                  vector.Vector3(0, _selectedButton == selection ? -7 : 0, 0),
                ),
                child: _selectedButton == selection
                    ? Image.asset(on)
                    : Container(),
              )),
          _selectedButton == selection
              ? Container()
              : Image.asset(
                  off,
                  width: 40,
                  height: 40,
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.likeButtonColor;

    final headline6 = AppFonts().headline6;

    final loveWidget = ValueListenableBuilder(
        valueListenable: _loveSelected,
        builder: (context, bool value, child) {
          return ContentButton(
            icon: Image.asset('assets/images/love.png'),
            onHover: () {
              _loveSelected.value = true;
            },
            onExit: () {
              _loveSelected.value = false;
            },
            text: Text(
              'Amei!',
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
            icon: buttonBuilder('assets/images/deslike_on.png',
                'assets/images/deslike.png', SelectedButton.deslike),
            text: Text(
              'Não é para mim',
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
            icon: buttonBuilder('assets/images/like_on.png',
                'assets/images/like.png', SelectedButton.like),
            text: Text(
              'Gostei',
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
            opacity: hover ? 1 : 0,
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
            opacity: hover ? 1 : 0,
            child: AnimatedContainer(
              duration: delay,
              margin: hover ? const EdgeInsets.only(left: 90) : EdgeInsets.zero,
              child: loveWidget,
            ),
          ),
          //
          // LikeButton
          //
          AnimatedContainer(
              margin: hover ? const EdgeInsets.only(left: 45) : EdgeInsets.zero,
              duration: delay,
              child: likeWidget),
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
