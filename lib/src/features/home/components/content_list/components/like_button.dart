import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  static const Duration delay = Duration(milliseconds: 200);

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

  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.likeButtonColor;

    final headline6 = AppFonts().headline6;

    final loveWidget = ContentButton(
      icon: Image.asset('images/love.png'),
      text: Text(
        'Amei!',
        textAlign: TextAlign.center,
        style: headline6.copyWith(color: Colors.black),
      ),
    );
    //
    final deslikeWidget = ContentButton(
      icon: Image.asset('images/deslike.png'),
      text: Text(
        'Não é para mim',
        textAlign: TextAlign.center,
        style: headline6.copyWith(color: Colors.black),
      ),
    );
    //
    final likeWidget = ContentButton(
      icon: Image.asset('images/like.png'),
      text: Text(
        'Gostei',
        textAlign: TextAlign.center,
        style: headline6.copyWith(color: Colors.black),
      ),
    );

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
