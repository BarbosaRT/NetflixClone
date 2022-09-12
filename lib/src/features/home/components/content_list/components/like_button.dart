import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  static const Duration delay = Duration(milliseconds: 200);

  static const likeWidget = ContentButton(
      icon: Icon(
        Icons.thumb_up,
        size: 25,
        color: Colors.white,
      ),
      text: 'Gostei');
  static const deslikeWidget = ContentButton(
      icon: Icon(
        Icons.thumb_down,
        size: 25,
        color: Colors.white,
      ),
      text: 'Não é para mim');
  static const loveWidget = ContentButton(
      icon: Icon(
        Icons.thumbs_up_down,
        size: 25,
        color: Colors.white,
      ),
      text: 'Amei!');
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
                    color: Colors.grey.shade800,
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
