import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HoverNotification extends ChangeNotifier {
  List<bool> _hoverOff = [false, false];
  List<bool> get hoverOff => _hoverOff;

  void clear() {
    _hoverOff = [true, true];
    notifyListeners();
  }

  void notify(bool value, int index) {
    if (_hoverOff[index] == value) {
      return;
    }
    print(hoverOff);
    _hoverOff[index] = value;
    notifyListeners();
  }
}

class HoverWidget extends StatefulWidget {
  final Widget? icon;
  final Widget? child;
  final double maxWidth;
  final double rightPadding;
  final int index;
  final void Function()? onHover;
  final void Function()? onExit;

  const HoverWidget({
    super.key,
    this.child,
    this.icon,
    this.maxWidth = 400,
    this.rightPadding = 30,
    this.onHover,
    this.onExit,
    this.index = 0,
  });

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _hover = false;
  bool _isHover = false;

  Duration currentdelayOut = const Duration(milliseconds: 300);
  static const delayOut = Duration(milliseconds: 300);

  HoverNotification? hoverNotification;

  Duration currentfadeDuration = const Duration(milliseconds: 50);
  static const fadeDuration = Duration(milliseconds: 50);

  final Random random = Random(6941);

  @override
  void initState() {
    super.initState();
    currentdelayOut = Duration(milliseconds: delayOut.inMilliseconds);
    currentfadeDuration = Duration(milliseconds: fadeDuration.inMilliseconds);

    hoverNotification = Modular.get<HoverNotification>();
    hoverNotification!.addListener(() {
      if (hoverNotification!.hoverOff[widget.index]) {
        hoverOff();
      }
    });
  }

  void hoverOff() {
    currentfadeDuration = Duration.zero;
    currentdelayOut = Duration.zero;
    _isHover = false;

    if (widget.onExit != null) {
      widget.onExit!();
    }

    setState(() {
      _hover = false;
    });
    hoverNotification!.notify(false, widget.index);
  }

  void onExit() {
    _isHover = false;
    if (widget.onExit != null) {
      widget.onExit!();
    }

    Future.delayed(currentdelayOut).then(
      (value) {
        if (_isHover) {
          return;
        }
        setState(() {
          _hover = false;
        });
      },
    );
  }

  void onHover() {
    hoverNotification!.clear();
    hoverNotification!.notify(false, widget.index);
    if (widget.onHover != null) {
      widget.onHover!();
    }

    currentfadeDuration = Duration(milliseconds: fadeDuration.inMilliseconds);
    currentdelayOut = Duration(milliseconds: delayOut.inMilliseconds);

    _isHover = true;
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      width: widget.maxWidth,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            left: widget.maxWidth - widget.rightPadding,
            child: MouseRegion(
              opaque: false,
              onExit: (event) {
                onExit();
              },
              onHover: (v) {
                onHover();
              },
              child: widget.icon,
            ),
          ),
          _hover
              ? Positioned(
                  top: 30,
                  child: MouseRegion(
                    onExit: (event) {
                      onExit();
                    },
                    onHover: (v) {
                      onHover();
                    },
                    child: currentfadeDuration != Duration.zero
                        ? AnimatedOpacity(
                            opacity: _hover ? 1 : 0,
                            duration: currentfadeDuration,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: widget.child,
                            ),
                          )
                        : Container(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
