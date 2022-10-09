import 'package:flutter/material.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_container.dart';

enum ContentContainerAnchor { left, center, right }

// Responsible for putting one widget on top of another
class ContentInnerWidget extends StatefulWidget {
  final int index;
  final String id;
  final List<ContentModel> contents;
  final void Function(bool value)? onHover;
  final void Function(bool value) onPlay;
  final int contentCount;
  const ContentInnerWidget(
      {Key? key,
      this.index = 0,
      this.onHover,
      required this.onPlay,
      this.contentCount = 5,
      required this.id,
      required this.contents})
      : super(key: key);

  @override
  State<ContentInnerWidget> createState() => _ContentInnerWidgetState();
}

class _ContentInnerWidgetState extends State<ContentInnerWidget> {
  static const Duration duration = Duration(milliseconds: 300);
  static const double spacing = 252.0;
  int current = 0;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];

  @override
  void initState() {
    widgetBuilder();
    super.initState();
  }

  void widgetBuilder() {
    for (int i = widget.contentCount - 1; i >= 0; i--) {
      widgets.add(
        Positioned(
          key: UniqueKey(),
          left: spacing * i,
          child: ContentContainer(
            key: UniqueKey(),
            onHover: onHover,
            id: widget.id,
            onPlay: widget.onPlay,
            onExit: () {
              onChangeValue(false);
            },
            anchor: getAnchor(i),
            localIndex: i,
            content: widget.contents[i],
          ),
        ),
      );
    }
    oldWidgets = widgets.toList();
  }

  ContentContainerAnchor getAnchor(int i) {
    int v = i >= widget.contentCount
        ? i - widget.contentCount * (i ~/ widget.contentCount)
        : i;

    List<ContentContainerAnchor> anchors = [
      ContentContainerAnchor.left,
    ];
    for (int i = 0; i < widget.contentCount - 2; i++) {
      anchors.add(ContentContainerAnchor.center);
    }
    anchors.add(ContentContainerAnchor.right);
    return anchors[v];
  }

  void onChangeValue(bool value) {
    if (widget.onHover != null) {
      widget.onHover!(value);
    }
  }

  void onHover(int index) {
    if (current == index) {
      return;
    }
    current = index;
    onChangeValue(true);
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
      width: spacing * widget.contentCount,
      height: 500,
      child: Stack(
        children: widgets,
      ),
    );
  }
}
