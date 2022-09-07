import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';

class ContentButton extends StatefulWidget {
  final Widget icon;
  const ContentButton({super.key, required this.icon});

  @override
  State<ContentButton> createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  @override
  Widget build(BuildContext context) {
    return HoverWidget(
        useNotification: false,
        delayOut: Duration.zero,
        fadeDuration: Duration.zero,
        type: HoverType.top,
        icon: Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: widget.icon),
        child: Text('TESTE', style: TextStyle(color: Colors.white)));
  }
}
