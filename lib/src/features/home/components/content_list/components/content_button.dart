import 'package:flutter/material.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';

class ContentButton extends StatefulWidget {
  final Widget icon;
  final String text;
  final double distance;
  const ContentButton(
      {super.key, required this.icon, required this.text, this.distance = 70});

  @override
  State<ContentButton> createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  static const double width = 250;

  @override
  Widget build(BuildContext context) {
    final headline6 = AppFonts().headline6;

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
        icon: Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: widget.icon),
        child: SizedBox(
          height: 100,
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: 12,
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
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: headline6.copyWith(color: Colors.black),
                        ),
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
