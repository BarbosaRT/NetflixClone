import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SmoothScroll extends StatefulWidget {
  ///Same ScrollController as the child widget's.
  final ScrollController controller;

  ///Child scrollable widget.
  final Widget child;

  ///Scroll speed px/scroll.
  final int scrollSpeed;

  ///Scroll animation length in milliseconds.
  final int scrollAnimationLength;

  ///Curve of the animation.
  final Curve curve;

  const SmoothScroll({
    super.key,
    required this.controller,
    required this.child,
    this.scrollSpeed = 250,
    this.scrollAnimationLength = 130,
    this.curve = Curves.linear,
  });

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  double _scroll = 0;

  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(() {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      if (widget.controller.position.activity is IdleScrollActivity) {
        _scroll = widget.controller.position.extentBefore;
      }
    });

    return Listener(
      onPointerSignal: (pointerSignal) {
        int millis = widget.scrollAnimationLength;
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy > 0) {
            _scroll += widget.scrollSpeed;
          } else {
            _scroll -= widget.scrollSpeed;
          }
          if (_scroll > widget.controller.position.maxScrollExtent) {
            _scroll = widget.controller.position.maxScrollExtent;
            millis = widget.scrollAnimationLength ~/ 2;
          }
          if (_scroll < 0) {
            _scroll = 0;
            millis = widget.scrollAnimationLength ~/ 2;
          }

          widget.controller.animateTo(
            _scroll,
            duration: Duration(milliseconds: millis),
            curve: widget.curve,
          );
        }
      },
      child: widget.child,
    );
  }
}
