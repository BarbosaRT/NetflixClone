import 'package:flutter/material.dart';

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
    print(hover);

    return SizedBox(
      height: 1000,
      width: 500,
      child: Stack(
        children: [
          Positioned(
            left: 420,
            child: MouseRegion(
              opaque: false,
              onExit: (event) {
                setState(() {
                  hover = false;
                });
              },
              onHover: (v) {
                setState(() {
                  hover = true;
                });
              },
              child: widget.icon,
            ),
          ),
          hover
              ? Positioned(
                  top: 50,
                  child: MouseRegion(
                      onExit: (event) {
                        setState(() {
                          hover = false;
                        });
                      },
                      onHover: (v) {
                        setState(() {
                          hover = true;
                        });
                      },
                      child: Container(
                          width: 450, height: 300, color: Colors.blue)),
                )
              : Container(),
        ],
      ),
    );
  }
}
