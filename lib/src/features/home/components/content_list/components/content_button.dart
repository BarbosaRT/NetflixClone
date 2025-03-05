import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';

class ContentButton extends StatefulWidget {
  final Widget icon;
  final Widget text;
  final double distance;
  final void Function()? onClick;
  final void Function()? onHover;
  final void Function()? onExit;
  final Color circleColor;
  final double opacity;
  final Color buttonColor;
  final double rightPadding;
  final bool hoverActive;
  const ContentButton({
    super.key,
    required this.icon,
    required this.text,
    this.hoverActive = true,
    this.circleColor = Colors.grey,
    this.buttonColor = Colors.grey,
    this.distance = 70,
    this.opacity = 0.0,
    this.onClick,
    this.onHover,
    this.onExit,
    this.rightPadding = 0,
  });

  @override
  State<ContentButton> createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  static const double width = 250;
  bool isHover = false;

  void onClick() {
    if (widget.onClick != null) {
      widget.onClick!();
    }
  }

  void onHover() {
    isHover = true;
    if (widget.onHover != null) {
      widget.onHover!();
    }
  }

  void onExit() {
    isHover = false;
    if (widget.onExit != null) {
      widget.onExit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
        useNotification: false,
        delayOut: Duration.zero,
        fadeDuration: Duration.zero,
        type: HoverType.top,
        rightPadding: width / 2 + 20,
        maxWidth: width,
        maxHeight: 200,
        distance: widget.distance,
        detectChildArea: false,
        onExit: onExit,
        onHover: onHover,
        icon: GestureDetector(
          onTap: () {
            onClick();
          },
          child: SizedBox(
            width: 40,
            height: 40,
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isHover && widget.hoverActive
                          ? Colors.white
                          : widget.circleColor,
                      width: 1),
                  shape: BoxShape.circle,
                  color: widget.buttonColor.withValues(alpha: widget.opacity),
                ),
                child: widget.icon),
          ),
        ),
        child: SizedBox(
          height: 100,
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: widget.rightPadding,
                child: SizedBox(
                  width: width,
                  height: 50,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.text,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                  top: 35,
                  child: SizedBox(
                      width: width,
                      height: 50,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.white,
                        ),
                      ))),
            ],
          ),
        ));
  }
}
