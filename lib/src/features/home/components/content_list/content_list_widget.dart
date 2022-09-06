import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContentListWidget extends StatefulWidget {
  final int index;
  final String title;
  final ContentListAnchor anchor;
  final void Function() onHover;
  const ContentListWidget(
      {super.key,
      required this.index,
      required this.title,
      required this.anchor,
      required this.onHover});

  @override
  State<ContentListWidget> createState() => _ContentListWidgetState();
}

class _ContentListWidgetState extends State<ContentListWidget> {
  static const double distanceToTop = 90;
  static const duration = Duration(milliseconds: 500);
  bool textSelected = false;
  bool listSelected = false;
  bool leftActive = false;

  final int widgetCount = 5;
  List<Widget> widgetList = [];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int currentIndex = 0;

  @override
  void initState() {
    widgetBuilder();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToIndex(currentIndex, duration),
    );
  }

  Future _scrollToIndex(int index, Duration delay) async {
    if (delay == Duration.zero) {
      itemScrollController.jumpTo(alignment: 0.04, index: index);
    } else {
      itemScrollController.scrollTo(
        alignment: 0.04,
        index: index,
        duration: delay,
        curve: Curves.easeInOut,
      );
    }
  }

  void widgetBuilder() {
    widgetList = [];

    if (leftActive) {
      // Widgets before :)
      for (int i = 0; i < 2; i++) {
        widgetList.add(
          ContentInnerWidget(index: widgetCount - i),
        );
      }
    } else {
      widgetList.add(const SizedBox(
        width: 50,
        height: 132,
      ));
    }

    // Widgets itself :)
    for (int i = 2; i < widgetCount + 2; i++) {
      widgetList.add(
        ContentInnerWidget(index: i - 2),
      );
    }

    // Widgets after :)
    for (int i = widgetCount; i < widgetCount + 2; i++) {
      widgetList.add(
        ContentInnerWidget(index: i - widgetCount),
      );
    }
  }

  void returnScroll(int index) {
    final secondDuration =
        Duration(milliseconds: duration.inMilliseconds + 100);
    Future.delayed(secondDuration).then((value) {
      currentIndex = index;
      _scrollToIndex(currentIndex, Duration.zero);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void moveBackward() {
    if (currentIndex <= 2) {
      returnScroll(widgetCount + 1);
    }
    currentIndex -= 1;
    if (mounted) {
      setState(() {});
    }
    _scrollToIndex(currentIndex, duration);
  }

  void activeLeft() {
    if (leftActive) {
      return;
    }
    leftActive = true;
    widgetBuilder();
  }

  void moveForward() {
    if (!leftActive) {
      currentIndex = 1;
    }
    if (currentIndex > widgetCount) {
      returnScroll(2);
    }
    currentIndex += 1;
    if (mounted) {
      activeLeft();
      setState(() {});
    }
    _scrollToIndex(currentIndex, duration);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final headline6 = AppFonts().headline6;
    print('build');
    return SizedBox(
        width: 1360,
        height: 450,
        child: Stack(
          children: [
            //
            // Title
            //
            Positioned(
              top: distanceToTop,
              left: 50,
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: headline6,
                  ),
                  textSelected
                      ? const Icon(CupertinoIcons.forward,
                          color: Colors.blue, size: 20)
                      : Container(
                          height: 20,
                        ),
                ],
              ),
            ),
            listSelected
                ? Positioned(
                    top: distanceToTop + 13,
                    left: width * 0.9,
                    child: Row(
                      children: [
                        for (int i = 0; i < widgetCount; i++)
                          Container(
                            width: 13,
                            height: 2,
                            color: i == currentIndex - (leftActive ? 2 : 0)
                                ? Colors.grey
                                : Colors.grey.shade800,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                          ),
                      ],
                    ),
                  )
                : Container(),
            //
            // List
            //
            SizedBox(
              width: width,
              height: 500,
              child: ScrollablePositionedList.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widgetList.length,
                itemBuilder: (context, index) => widgetList[index],
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              ),
            ),
            //
            // Buttons
            //
            listSelected
                ? Positioned(
                    top: 120,
                    child: SizedBox(
                        width: width,
                        height: 140,
                        child: Row(
                          children: [
                            Container(
                              height: 145,
                              width: 50,
                              color: Colors.black.withOpacity(0.3),
                              child: leftActive
                                  ? IconButton(
                                      onPressed: () {
                                        moveBackward();
                                      },
                                      icon: const Icon(Icons.arrow_back_ios,
                                          color: Colors.white),
                                    )
                                  : Container(),
                            ),
                            const Spacer(),
                            Container(
                              height: 145,
                              width: 50,
                              color: Colors.black.withOpacity(0.3),
                              child: IconButton(
                                onPressed: () {
                                  moveForward();
                                },
                                icon: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                  )
                : Container(),
            //
            // MouseRegion of the text
            //
            Positioned(
              top: distanceToTop,
              child: MouseRegion(
                opaque: false,
                onEnter: (event) {
                  setState(() {
                    textSelected = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    textSelected = false;
                  });
                },
                // For Debugging
                child: Container(
                    width: 1360,
                    height: 185,
                    color: Colors.green.withOpacity(0.0)),
              ),
            ),
            //
            // MouseRegion of the list
            //
            Positioned(
                top: 120,
                child: MouseRegion(
                    opaque: false,
                    onEnter: (event) {
                      widget.onHover();
                      setState(() {
                        listSelected = true;
                      });
                    },
                    onHover: (event) {
                      widget.onHover();
                      setState(() {
                        listSelected = true;
                      });
                    },
                    onExit: (event) {
                      Future.delayed(const Duration(milliseconds: 200)).then(
                        (value) {
                          setState(() {
                            listSelected = false;
                          });
                        },
                      );
                    },
                    // For debugging
                    child: Container(
                      width: 1360,
                      height: 140,
                      color: Colors.purple.withOpacity(0.0),
                    ))),
          ],
        ));
  }
}
