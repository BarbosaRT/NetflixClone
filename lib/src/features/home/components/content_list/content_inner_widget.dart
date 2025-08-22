import 'package:flutter/material.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_container.dart';

enum ContentContainerAnchor { left, center, right }

// Responsible for putting one widget on top of another with adaptive container count
class ContentInnerWidget extends StatefulWidget {
  final int index;
  final String id;
  final List<ContentModel> contents;
  final void Function(ContentModel content)? onDetail;
  final void Function(bool value)? onHover;
  final void Function(bool value) onPlay;
  final int contentCount; // This becomes the base/default count
  const ContentInnerWidget(
      {Key? key,
      this.index = 0,
      this.onHover,
      this.onDetail,
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
  int current = 0;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];
  int screenWidth = 1280;
  int adaptiveContentCount = 5; // This will change based on screen size

  @override
  void initState() {
    super.initState();
  }

  // Get actual container dimensions accounting for scaling
  double getScaledContainerWidth(double screenWidth) {
    final double scale = (screenWidth / 1366).clamp(0.9, 1.07);
    return 245 * scale; // Base width from ContentContainer
  }

  // Calculate how many containers can fit with proper spacing (5-25px)
  int calculateAdaptiveContentCount(double screenWidth) {
    double availableWidth = screenWidth; // Account for margins/arrows
    double scaledContainerWidth = getScaledContainerWidth(screenWidth);

    // Try different container counts and see what fits with good spacing
    for (int count = 6; count >= 4; count--) {
      double remainingWidth = availableWidth - (scaledContainerWidth * count);
      double spacingNeeded = remainingWidth / (count - 1);

      // Check if spacing is within our desired range (5-25px)
      if (spacingNeeded >= 5 && spacingNeeded <= 25) {
        return count;
      }
    }

    // Fallback: calculate based on minimum spacing
    double minSpacing = 5; // Minimum 8px spacing
    int maxContainers =
        ((availableWidth + minSpacing) / (scaledContainerWidth + minSpacing))
            .floor();
    return maxContainers.clamp(4, 6);
  }

  // Calculate optimal spacing between containers
  double calculateSpacing(int containerCount, double screenWidth) {
    if (containerCount <= 1) return 0;

    double availableWidth = screenWidth;
    double scaledContainerWidth = getScaledContainerWidth(screenWidth);
    double totalContainerWidth = scaledContainerWidth * containerCount;
    double remainingWidth = availableWidth - totalContainerWidth;

    // Distribute remaining width evenly between containers
    double spacing = remainingWidth / (containerCount - 1);

    // Clamp spacing to our desired range
    return spacing.clamp(5.0, 7.0);
  }

  void widgetBuilder() {
    widgets = [];
    adaptiveContentCount =
        calculateAdaptiveContentCount(screenWidth.toDouble());
    double spacing =
        calculateSpacing(adaptiveContentCount, screenWidth.toDouble());
    double scaledContainerWidth =
        getScaledContainerWidth(screenWidth.toDouble());
    double adaptiveSpacing = scaledContainerWidth + spacing;

    for (int i = adaptiveContentCount - 1; i >= 0; i--) {
      int contentIndex = widget.index * adaptiveContentCount + i;

      // Handle content bounds
      if (contentIndex > widget.contents.length - 1) {
        contentIndex = widget.contents.length - 1;
      }
      if (contentIndex < 0) {
        contentIndex = 0;
      }

      // Handle case where we don't have enough content
      if (contentIndex >= widget.contents.length) {
        continue;
      }

      widgets.add(
        Positioned(
          key: UniqueKey(),
          left: adaptiveSpacing * i,
          child: ContentContainer(
              key: UniqueKey(),
              onHover: onHover,
              id: widget.id,
              onPlay: widget.onPlay,
              onExit: () {
                onChangeValue(false);
              },
              anchor: getAnchor(i, adaptiveContentCount),
              localIndex: i,
              content: widget.contents[contentIndex],
              onDetail: (ContentModel content) {
                if (widget.onDetail != null) {
                  widget.onDetail!(content);
                }
              }),
        ),
      );
    }
    oldWidgets = widgets.toList();
  }

  // Modified to accept dynamic container count
  ContentContainerAnchor getAnchor(int i, int containerCount) {
    int v =
        i >= containerCount ? i - containerCount * (i ~/ containerCount) : i;

    List<ContentContainerAnchor> anchors = [
      ContentContainerAnchor.left,
    ];

    // Add center anchors for middle containers
    for (int j = 0; j < containerCount - 2; j++) {
      anchors.add(ContentContainerAnchor.center);
    }

    // Add right anchor for last container (if more than 1 container)
    if (containerCount > 1) {
      anchors.add(ContentContainerAnchor.right);
    }

    return anchors[v.clamp(0, anchors.length - 1)];
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

    switch (getAnchor(index, adaptiveContentCount)) {
      case ContentContainerAnchor.center:
        Future.delayed(duration).then((v) {
          widgets = oldWidgets.toList();
          if (widgets.length - index < 0) {
            return;
          }
          Widget element = widgets[widgets.length - index];

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
    final currentScreenWidth = MediaQuery.of(context).size.width.toInt();

    int newAdaptiveCount =
        calculateAdaptiveContentCount(currentScreenWidth.toDouble());

    if (screenWidth != currentScreenWidth ||
        adaptiveContentCount != newAdaptiveCount) {
      screenWidth = currentScreenWidth;
      widgetBuilder();
    }

    Color test = Color.fromRGBO(widget.index * 50, widget.index * 50, 0, 0);

    return Container(
      width: currentScreenWidth.toDouble(),
      height: 540,
      color: test,
      child: Stack(
        children: widgets,
      ),
    );
  }
}
