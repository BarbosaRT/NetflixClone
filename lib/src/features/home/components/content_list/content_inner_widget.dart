import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/content_list/content_container.dart';

enum ContentContainerAnchor { left, center, right }

class ContentInnerWidget extends StatefulWidget {
  final int index;
  const ContentInnerWidget({Key? key, this.index = 0}) : super(key: key);

  @override
  State<ContentInnerWidget> createState() => _ContentInnerWidgetState();
}

class _ContentInnerWidgetState extends State<ContentInnerWidget> {
  static const Duration duration = Duration(milliseconds: 300);
  static const double spacing = 252.0;
  int current = 0;
  static const int contentCount = 5;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];

  @override
  void initState() {
    widgetBuilder();
    super.initState();
  }

  void widgetBuilder() {
    for (int i = contentCount - 1; i >= 0; i--) {
      widgets.add(
        Positioned(
          left: spacing * i,
          child: ContentContainer(
            onHover: onHover,
            anchor: getAnchor(i),
            localIndex: i,
            index: widget.index * contentCount + i,
          ),
        ),
      );
    }
    oldWidgets = widgets.toList();
  }

  ContentContainerAnchor getAnchor(int i) {
    int v = i >= contentCount ? i - contentCount * (i ~/ contentCount) : i;

    List<ContentContainerAnchor> anchors = [
      ContentContainerAnchor.left,
    ];
    for (int i = 0; i < contentCount - 2; i++) {
      anchors.add(ContentContainerAnchor.center);
    }
    anchors.add(ContentContainerAnchor.right);
    return anchors[v];
  }

  void onHover(int index) {
    if (current == index) {
      return;
    }
    current = index;
    switch (getAnchor(index)) {
      case ContentContainerAnchor.center:
        Future.delayed(duration).then((v) {
          //
          widgets = oldWidgets.toList();
          if (widgets.length - index < 0) {
            return;
          }
          Widget element = widgets[widgets.length - index];
          //
          widgets.removeAt(widgets.length - index);
          widgets.insert(widgets.length - index, element);

          if (mounted) {
            setState(() {});
          }
        });
        break;
      case ContentContainerAnchor.left:
        Future.delayed(duration).then((v) {
          if (mounted) {
            setState(() {
              widgets = oldWidgets.toList();
            });
          }
        });
        break;
      case ContentContainerAnchor.right:
        Future.delayed(duration).then((v) {
          if (mounted) {
            setState(() {
              widgets = oldWidgets.reversed.toList();
            });
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spacing * contentCount,
      height: 500,
      child: Stack(
        children: widgets,
      ),
    );
  }
}
