import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final TextStyle textStyle;
  final Color overlayColor;
  final Color buttonColor;
  final IconData icon;
  final String text;
  final double iconSize;
  final EdgeInsets padding;
  final double spacing;
  const HomeButton(
      {super.key,
      required this.textStyle,
      required this.overlayColor,
      required this.buttonColor,
      required this.icon,
      required this.text,
      this.spacing = 4,
      this.iconSize = 40,
      this.padding = const EdgeInsets.only(left: 10, right: 25)});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.all(overlayColor),
            backgroundColor: MaterialStateProperty.all(buttonColor)),
        onPressed: () {},
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: textStyle.color,
                size: iconSize,
              ),
              SizedBox(
                width: spacing,
              ),
              Text(
                text,
                style: textStyle,
              ),
            ],
          ),
        ));
  }
}
