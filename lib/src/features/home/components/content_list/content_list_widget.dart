import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';

class ContentListWidget extends StatefulWidget {
  final int index;
  final String title;
  final ContentListAnchor anchor;
  final bool disable;
  final int initialPage;
  final int contentCount; // how many content_container
  final int listCount; // how many inner_widgets
  final void Function() onHover;
  final void Function(bool value)? onPlay;
  final void Function(String content)? onSeeMore;
  final void Function(ContentModel content)? onDetail;
  const ContentListWidget({
    super.key,
    required this.index,
    required this.title,
    required this.anchor,
    required this.onHover,
    this.onDetail,
    this.onSeeMore,
    this.disable = false,
    this.contentCount = 5,
    this.listCount = 5,
    this.initialPage = 0,
    this.onPlay,
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
  bool loaded = false;

  List<List<ContentModel>> contents = List.generate(
    36,
    (index) => List.generate(
      40,
      (index) => ContentModel.fromJson(AppConsts.placeholderJson),
    ),
  );

  List<Widget> widgetList = [];
  late CarouselController controller;
  int currentIndex = 0;
  bool initialized = false;
  @override
  void initState() {
    if (widgetList.isEmpty) {
      controller = CarouselController();
      if (!initialized) {
        initContents().then(
          (v) {
            widgetBuilder();
          },
        );
      }
    }
    final contentController = Modular.get<ContentController>();
    if (contentController.loading) {
      contentController.init();
    } else {
      if (!initialized) {
        initContents().then(
          (v) {
            widgetBuilder();
          },
        );
      }
    }
    super.initState();

    contentController.addListener(() {
      if (!contentController.loading && !loaded) {
        if (!initialized) {
          initContents().then(
            (v) {
              widgetBuilder();
              if (mounted) {
                setState(() {});
              }
            },
          );
        }
      }
    });
  }

  Future<void> initContents() async {
    initialized = true;
    contents = [];
    final contentController = Modular.get<ContentController>();
    for (var i = widget.initialPage;
        i < widget.listCount + widget.initialPage;
        i++) {
      final List<ContentModel> l = [];
      for (var j = 0; j < widget.contentCount; j++) {
        ContentModel value = await contentController.getContent(
            widget.title, i * widget.contentCount + j);
        l.add(value);
      }
      contents.add(l.toList());
    }
    loaded = true;
    if (mounted) {
      setState(() {});
    }
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
    for (int i = 0; i < widget.listCount; i++) {
      widgetList.add(
        ContentInnerWidget(
            key: UniqueKey(),
            id: widget.title,
            index: i,
            contentCount: widget.contentCount,
            contents: contents[i],
            onPlay: (bool value) {
              if (widget.onPlay != null) {
                widget.onPlay!(value);
              }
            },
            onHover: (value) {
              onWidgetChanging(value);
            },
            onDetail: (ContentModel content) {
              if (widget.onDetail != null) {
                widget.onDetail!(content);
              }
            }),
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

  void activeLeft() async {
    if (leftActive) {
      return;
    }
    leftActive = true;

    final contentController = Modular.get<ContentController>();
    await contentController.getContent(widget.title, 0);

    widgetBuilder();
    controller.jumpToPage(widget.listCount);
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
    final colorController = Modular.get<ColorController>();

    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

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
                      widget.disable
                          ? Container()
                          : Text(
                              widget.title,
                              style: headline6,
                            ),
                      widget.disable
                          ? Container()
                          : ValueListenableBuilder(
                              valueListenable: _seeMoreSelected,
                              builder: (BuildContext context, bool val,
                                  Widget? child) {
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
                      widget.disable
                          ? Container()
                          : ValueListenableBuilder(
                              valueListenable: _seeMoreSelected,
                              builder: (BuildContext context, bool val,
                                  Widget? child) {
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
                                        child: const Icon(
                                            CupertinoIcons.forward,
                                            color: Colors.blue,
                                            size: 20),
                                      );
                                    },
                                  ),
                                );
                              })
                    ],
                  ),
                ),
              ),
              widget.disable
                  ? Container()
                  : ValueListenableBuilder(
                      valueListenable: _listSelected,
                      builder: (BuildContext context, bool val, Widget? child) {
                        return val
                            ? Positioned(
                                top: distanceToTop + 13,
                                left: width * 0.9,
                                child: Row(
                                  children: [
                                    for (int i = 0; i < widget.listCount; i++)
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
              widget.disable
                  ? Container()
                  : ValueListenableBuilder(
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
                                    color: leftActive
                                        ? Colors.black.withOpacity(0.3)
                                        : backgroundColor,
                                    child: leftActive && val
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
                      if (widget.onSeeMore != null) {
                        widget.onSeeMore!(widget.title);
                      }
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
