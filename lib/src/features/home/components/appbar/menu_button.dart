import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final Widget child;
  final Widget showWidget;
  const MenuButton({super.key, required this.child, required this.showWidget});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
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
            child: widget.child),
        const SizedBox(
          height: 30,
        ),
        selected ? widget.showWidget : Container(),
      ],
    );
  }
}
