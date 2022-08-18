import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HoverWidget extends StatefulWidget {
  final icon;
  final child;
  const HoverWidget({super.key, this.child, this.icon});

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onExit: (event) {
          setState(() {
            hover = false;
          });
        },
        //
        //
        onHover: (v) {
          setState(() {
            hover = true;
          });
        },
        child: Stack(children: [
          widget.icon,
          hover
              ? Positioned(
                  top: 50,
                  child: Container(width: 50, height: 200, color: Colors.blue))
              : Container(),
        ]));
  }
}
