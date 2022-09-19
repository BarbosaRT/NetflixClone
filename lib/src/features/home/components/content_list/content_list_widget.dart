import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';

class ContentListWidget extends StatefulWidget {
  final int index;
  final String title;
  final ContentListAnchor anchor;
  final void Function() onHover;
  final void Function(String content) onSeeMore;
  const ContentListWidget({
    super.key,
    required this.index,
    required this.title,
    required this.anchor,
    required this.onHover,
    required this.onSeeMore,
  });

  @override
  State<ContentListWidget> createState() => _ContentListWidgetState();
}

class _ContentListWidgetState extends State<ContentListWidget> {
  static const double distanceToTop = 90;
  static const duration = Duration(milliseconds: 500);
  static const seeMoreDuration = Duration(milliseconds: 200);
  static const Curve curve = Curves.easeInOut;
  final ValueNotifier<bool> _listSelected = ValueNotifier(false);
  final ValueNotifier<bool> _seeMoreSelected = ValueNotifier(false);
  final ValueNotifier<bool> _textSelected = ValueNotifier(false);
  bool canDetectList = true;
  bool leftActive = false;

  final int widgetCount = 5;
  List<Widget> widgetList = [];

  late CarouselController controller;

  int currentIndex = 0;

  @override
  void initState() {
    if (widgetList.isEmpty) {
      controller = CarouselController();
      widgetBuilder();
    }
    super.initState();
  }

  @override
  void dispose() {
    _listSelected.dispose();
    super.dispose();
  }

  int getValueFromAnchor(ContentListAnchor anchor) {
    switch (anchor) {
      case ContentListAnchor.top:
        return 0;
      case ContentListAnchor.middle:
        return 1;
      case ContentListAnchor.bottom:
        return -1;
    }
  }

  void widgetBuilder() {
    widgetList = [];

    if (!leftActive) {
      widgetList.add(const SizedBox(
        width: 10,
        height: 100,
      ));
    }

    // Widgets itself :)
    for (int i = 0; i < widgetCount; i++) {
      widgetList.add(
        ContentInnerWidget(
          id: widget.title,
          index: i,
          onHover: (value) {
            onWidgetChanging(value);
          },
        ),
      );
    }
  }

  void onWidgetChanging(bool value) {
    // canDetectList = !value;
    // _listSelected.value = !value;
  }

  void moveBackward() {
    controller.previousPage(duration: duration, curve: curve);
  }

  void activeLeft() {
    if (leftActive) {
      return;
    }
    leftActive = true;
    widgetBuilder();
    controller.jumpToPage(widgetCount);
    Future.delayed(duration).then(
      (value) {
        moveForward();
      },
    );
  }

  void moveForward() {
    controller.nextPage(duration: duration, curve: curve);
    if (!leftActive) {
      activeLeft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final headline6 = AppFonts().headline6;
    final seeMoreStyle = headline6.copyWith(
      fontSize: headline6.fontSize! - 5,
      color: Colors.blue,
    );
    final contentController = Modular.get<ListContentController>();

    final textSize = TextPainter(
        text: TextSpan(text: widget.title, style: headline6),
        textDirection: TextDirection.ltr);
    textSize.layout();

    final seeMoreSize = TextPainter(
        text: TextSpan(text: 'Ver tudo', style: seeMoreStyle),
        textDirection: TextDirection.ltr);
    seeMoreSize.layout();

    return MouseRegion(
      opaque: false,
      child: SizedBox(
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
                child: SizedBox(
                  width: 1360,
                  height: 50,
                  child: Stack(
                    children: [
                      Text(
                        widget.title,
                        style: headline6,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _seeMoreSelected,
                          builder:
                              (BuildContext context, bool val, Widget? child) {
                            return AnimatedOpacity(
                                duration: seeMoreDuration,
                                opacity: val ? 1 : 0,
                                //
                                child: AnimatedContainer(
                                    margin: EdgeInsets.only(
                                        top: 3,
                                        left: val
                                            ? textSize.width + 15
                                            : textSize.width),
                                    duration: seeMoreDuration,
                                    child: Text(
                                      'Ver tudo',
                                      style: seeMoreStyle,
                                    )));
                          }),
                      ValueListenableBuilder(
                          valueListenable: _seeMoreSelected,
                          builder:
                              (BuildContext context, bool val, Widget? child) {
                            return AnimatedPositioned(
                              duration: seeMoreDuration,
                              left: val
                                  ? textSize.width + seeMoreSize.width + 15
                                  : textSize.width,
                              child: ValueListenableBuilder(
                                valueListenable: _textSelected,
                                builder: (BuildContext context, bool value,
                                    Widget? child) {
                                  return Opacity(
                                    opacity: value ? 1 : 0,
                                    child: const Icon(CupertinoIcons.forward,
                                        color: Colors.blue, size: 20),
                                  );
                                },
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _listSelected,
                  builder: (BuildContext context, bool val, Widget? child) {
                    return val
                        ? Positioned(
                            top: distanceToTop + 13,
                            left: width * 0.9,
                            child: Row(
                              children: [
                                for (int i = 0; i < widgetCount; i++)
                                  Container(
                                    width: 13,
                                    height: 2,
                                    color: i == currentIndex
                                        ? Colors.grey
                                        : Colors.grey.shade800,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                  ),
                              ],
                            ),
                          )
                        : Container();
                  }),
              //
              // List
              //
              SizedBox(
                width: width,
                height: 500,
                child: CarouselSlider(
                  items: widgetList,
                  carouselController: controller,
                  options: CarouselOptions(
                      initialPage: contentController.getPage(widget.index),
                      viewportFraction: 0.926,
                      onPageChanged: (index, reason) {
                        contentController.setPage(widget.index, index);
                        setState(() {
                          currentIndex = index;
                        });
                      }),
                ),
              ),
              //
              // Buttons
              //
              ValueListenableBuilder(
                  valueListenable: _listSelected,
                  builder: (BuildContext context, bool val, Widget? child) {
                    return Positioned(
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
                                child: leftActive && val
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
                                child: val
                                    ? IconButton(
                                        onPressed: () {
                                          moveForward();
                                        },
                                        icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white),
                                      )
                                    : Container(),
                              ),
                            ],
                          )),
                    );
                  }),
              //
              // MouseRegion of the text
              //
              Positioned(
                top: distanceToTop,
                child: MouseRegion(
                  opaque: false,
                  onEnter: (event) {
                    _textSelected.value = true;
                  },
                  onExit: (event) {
                    _textSelected.value = false;
                  },
                  // For Debugging
                  child: Container(
                      width: 1360,
                      height: 185,
                      color: Colors.green.withOpacity(0.0)),
                ),
              ),
              //
              // MouseRegion of the seeMore
              //
              Positioned(
                top: distanceToTop,
                left: 50,
                child: MouseRegion(
                  opaque: false,
                  onEnter: (event) {
                    _seeMoreSelected.value = true;
                  },
                  onExit: (event) {
                    _seeMoreSelected.value = false;
                  },
                  // For Debugging
                  child: TextButton(
                    onPressed: () {
                      widget.onSeeMore(widget.title);
                    },
                    child: Container(
                        width: textSize.width + 69,
                        height: 20,
                        color: Colors.blueGrey.withOpacity(0.0)),
                  ),
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
                        if (canDetectList) {
                          widget.onHover();
                          _listSelected.value = true;
                        }
                      },
                      onHover: (event) {
                        if (canDetectList && !_listSelected.value) {
                          widget.onHover();
                          _listSelected.value = true;
                        }
                      },
                      onExit: (event) {
                        if (canDetectList) {
                          Future.delayed(const Duration(milliseconds: 200))
                              .then(
                            (value) {
                              _listSelected.value = false;
                            },
                          );
                        }
                      },
                      // For debugging
                      child: Container(
                        width: 1360,
                        height: 140,
                        color: Colors.purple.withOpacity(0.0),
                      ))),
            ],
          )),
    );
  }
}
