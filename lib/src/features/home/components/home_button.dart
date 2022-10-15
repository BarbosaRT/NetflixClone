import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  final TextStyle textStyle;
  final Color overlayColor;
  final Color buttonColor;
  final IconData icon;
  final String text;
  final double iconSize;
  final EdgeInsets padding;
  final double spacing;
  final void Function()? onPressed;
  const HomeButton(
      {super.key,
      required this.textStyle,
      required this.overlayColor,
      required this.buttonColor,
      required this.icon,
      required this.text,
      this.spacing = 4,
      this.iconSize = 40,
      this.padding = const EdgeInsets.only(left: 10, right: 25),
      this.onPressed});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.all(
              hovered ? widget.overlayColor : widget.buttonColor),
          elevation: MaterialStateProperty.all(0),
        ),
        onHover: (value) => setState(() {
              hovered = value;
            }),
        onPressed: () {
          if (widget.onPressed != null) {
            widget.onPressed!.call();
          }
        },
        child: Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: widget.textStyle.color,
                size: widget.iconSize,
              ),
              SizedBox(
                width: widget.spacing,
              ),
              Text(
                widget.text,
                style: widget.textStyle,
              ),
            ],
          ),
        ));
  }
}
