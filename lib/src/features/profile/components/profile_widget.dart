import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';

class ProfileWidget extends StatefulWidget {
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String name;
  final String icon;
  final int index;
  const ProfileWidget(
      {super.key,
      required this.selectedStyle,
      required this.unselectedStyle,
      required this.name,
      required this.icon,
      required this.index});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
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
      onPressed: () {
        profileController.select(widget.index);
        Navigator.of(context).pushReplacementNamed('/splash');
      },
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
