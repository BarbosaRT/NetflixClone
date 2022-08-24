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
  bool _hover = false;

  void onExit() {
    setState(() {
      _hover = false;
    });
  }

  void onHover() {
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    return GestureDetector(
      onTap: () {
        profileController.select(widget.index);
        Navigator.of(context).pushReplacementNamed('/splash');
      },
      child: MouseRegion(
        onHover: (v) {
          onHover();
        },
        onExit: (v) {
          onExit();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: _hover
                    ? Border.all(width: 3, color: Colors.white)
                    : Border.all(width: 3, color: Colors.transparent),
                image: DecorationImage(
                  image: AssetImage(
                    widget.icon,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              style: _hover ? widget.selectedStyle : widget.unselectedStyle,
            )
          ],
        ),
      ),
    );
  }
}
