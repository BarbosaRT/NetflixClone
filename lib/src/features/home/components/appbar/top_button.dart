import 'package:flutter/material.dart';

class TopButton extends StatefulWidget {
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String name;
  const TopButton(
      {super.key,
      required this.selectedStyle,
      required this.unselectedStyle,
      required this.name});

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
      ),
      onHover: (v) {
        setState(() {
          selected = v;
        });
      },
      onPressed: () {},
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
    );
  }
}
