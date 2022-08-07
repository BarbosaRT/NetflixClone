import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String name;
  final String icon;
  const ProfileWidget(
      {super.key,
      required this.selectedStyle,
      required this.unselectedStyle,
      required this.name,
      required this.icon});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.grey.shade900),
        backgroundColor: MaterialStateProperty.all(Colors.grey.shade900),
        elevation: MaterialStateProperty.all(0),
      ),
      onHover: (v) {
        setState(() {
          selected = v;
        });
      },
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border:
                    selected ? Border.all(width: 3, color: Colors.white) : null,
                color: Colors.red),
            child: Image.asset(
              widget.icon,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.name,
            style: selected ? widget.selectedStyle : widget.unselectedStyle,
          )
        ],
      ),
    );
  }
}
