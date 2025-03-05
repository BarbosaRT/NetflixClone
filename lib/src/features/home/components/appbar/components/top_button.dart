import 'package:flutter/material.dart';

class TopButton extends StatefulWidget {
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String name;
  final void Function()? onClick;
  final double height;
  const TopButton(
      {super.key,
      this.height = 50,
      required this.selectedStyle,
      required this.unselectedStyle,
      required this.name,
      this.onClick});

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
      ),
      onHover: (v) {
        setState(() {
          selected = v;
        });
      },
      onPressed: () {
        if (widget.onClick != null) {
          widget.onClick!();
        }
      },
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: selected ? widget.selectedStyle : widget.unselectedStyle,
            ),
            const SizedBox(
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}
