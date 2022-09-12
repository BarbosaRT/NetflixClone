import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';

class ContentListWidget extends StatefulWidget {
  final int index;
  final String title;
  final ContentListAnchor anchor;
  //TODO: CarouselSlider not working
  final void Function() onHover;
  const ContentListWidget({
    super.key,
    required this.index,
    required this.title,
    required this.anchor,
    required this.onHover,
  });

  @override
  State<ContentListWidget> createState() => _ContentListWidgetState();
}

class _ContentListWidgetState extends State<ContentListWidget> {
  static const double distanceToTop = 90;
  static const duration = Duration(milliseconds: 500);
  static const Curve curve = Curves.easeInOut;
  final ValueNotifier<bool> _listSelected = ValueNotifier(false);
  bool textSelected = false;
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
          index: i,
          onHover: (value) {
            Future.delayed(const Duration(milliseconds: 200)).then((v) {
              onWidgetChanging(value);
            });
          },
        ),
      );
    }
  }

  void onWidgetChanging(bool value) {
    canDetectList = value;
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
  }

  void moveForward() {
    if (!leftActive) {
      activeLeft();
    }
    controller.nextPage(duration: duration, curve: curve);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final headline6 = AppFonts().headline6;

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
                child: Row(
                  children: [
                    Text(
                      '${widget.title} ${widget.index}',
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
                      initialPage: 1,
                      viewportFraction: 0.926,
                      onPageChanged: (index, reason) {
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
                    return val
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
                                              icon: const Icon(
                                                  Icons.arrow_back_ios,
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
                                        icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        : Container();
                  }),

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
