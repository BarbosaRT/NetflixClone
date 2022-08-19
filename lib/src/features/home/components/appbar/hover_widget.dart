import 'package:flutter/material.dart';

class HoverWidget extends StatefulWidget {
  final Widget? icon;
  final Widget? child;
  final double maxWidth;
  final double rightPadding;
  const HoverWidget(
      {super.key,
      this.child,
      this.icon,
      this.maxWidth = 400,
      this.rightPadding = 30});

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _hover = false;
  bool _isHover = false;

  void onExit() {
    _isHover = false;
    Future.delayed(const Duration(milliseconds: 50)).then(
      (value) {
        if (_isHover) {
          return;
        }
        setState(() {
          _hover = false;
        });
      },
    );
  }

  void onHover() {
    _isHover = true;
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      width: widget.maxWidth,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            left: widget.maxWidth - widget.rightPadding,
            child: MouseRegion(
              opaque: false,
              onExit: (event) {
                onExit();
              },
              onHover: (v) {
                onHover();
              },
              child: widget.icon,
            ),
          ),
          _hover
              ? Positioned(
                  top: 40,
                  child: MouseRegion(
                    onExit: (event) {
                      onExit();
                    },
                    onHover: (v) {
                      onHover();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: widget.child,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
