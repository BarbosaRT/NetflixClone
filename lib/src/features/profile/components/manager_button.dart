import 'package:flutter/material.dart';

class ManagerButton extends StatefulWidget {
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;

  const ManagerButton(
      {super.key, required this.selectedStyle, required this.unselectedStyle});

  @override
  State<ManagerButton> createState() => _ManagerButtonState();
}

class _ManagerButtonState extends State<ManagerButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                    side: BorderSide(
                        color:
                            selected ? Colors.white : Colors.grey.shade400)))),
        onHover: (v) {
          setState(() {
            selected = v;
          });
        },
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Text(
            'Gerenciar perfis',
            style: selected ? widget.selectedStyle : widget.unselectedStyle,
          ),
        ));
  }
}
