import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/content_list/content_list_controller.dart';

class ContentListWidget extends StatefulWidget {
  final int index;
  final String title;
  const ContentListWidget(
      {super.key, required this.index, required this.title});

  @override
  State<ContentListWidget> createState() => _ContentListWidgetState();
}

class _ContentListWidgetState extends State<ContentListWidget> {
  bool textSelected = false;
  bool listSelected = false;

  double movingValue = 1254;
  final ScrollController _scrollController = ScrollController();
  static const duration = Duration(milliseconds: 500);

  List<Widget> widgets = [];

  static const double distanceToTop = 90;

  @override
  void initState() {
    super.initState();

    final controller = Modular.get<ContentListController>();

    controller.init(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widgets = controller.widgets[widget.index]!.toList();
        _scrollController.jumpTo(movingValue);
      });
      controller.addListener(() {
        widgetController();
      });
    });
  }

  void move() {
    final controller = Modular.get<ContentListController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
          movingValue * controller.selectedIndexes[widget.index] +
              5 * controller.selectedIndexes[widget.index],
          duration: duration,
          curve: Curves.easeInOut);
    });
  }

  void moveForward() {
    final controller = Modular.get<ContentListController>();
    if (controller.selectedIndexes[widget.index] >=
        controller.contentLengths[widget.index] ~/ 5) {
      final secondDuration =
          Duration(milliseconds: duration.inMilliseconds + 200);
      move();
      Future.delayed(secondDuration).then(
        (value) {
          controller.changeIndex(1, widget.index);
          _scrollController.jumpTo(
            movingValue,
          );
        },
      );
    } else {
      move();
    }
    controller.changeIndex(
        controller.selectedIndexes[widget.index] + 1, widget.index);
    controller.enableLeft(widget.index);
  }

  void moveBackward() {
    final controller = Modular.get<ContentListController>();
    if (controller.selectedIndexes[widget.index] <= 1) {
      controller.changeIndex(
          controller.contentLengths[widget.index] ~/ 5, widget.index);

      final secondDuration =
          Duration(milliseconds: duration.inMilliseconds + 100);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(10,
            duration: duration, curve: Curves.easeInOut);

        Future.delayed(secondDuration).then((value) {
          _scrollController.jumpTo(
            movingValue * controller.selectedIndexes[widget.index] +
                5 * controller.selectedIndexes[widget.index],
          );
        });
      });
    } else {
      move();

      controller.changeIndex(
          controller.selectedIndexes[widget.index] - 1, widget.index);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void widgetController() {
    final controller = Modular.get<ContentListController>();
    setState(() {
      widgets = controller.widgets[widget.index]!.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<ContentListController>();
    final width = MediaQuery.of(context).size.width;
    final headline6 = AppFonts().headline6;

    return SizedBox(
      width: 1360,
      height: 450,
      child: Stack(children: [
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
                    for (int i = 0;
                        i < (controller.contentLengths[widget.index]) ~/ 5;
                        i++)
                      Container(
                        width: 13,
                        height: 2,
                        color: i == controller.selectedIndexes[widget.index] - 1
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
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: SizedBox(
            height: 500,
            width: controller.spacing * 45,
            child: Stack(children: widgets),
          ),
        ),
        //
        // Buttons
        //
        Positioned(
          top: 120,
          child: SizedBox(
              width: width,
              height: 140,
              child: Row(
                children: [
                  controller.enabledLefts[widget.index]
                      ? Container(
                          height: 140,
                          width: 50,
                          color: Colors.black.withOpacity(0.3),
                          child: listSelected
                              ? IconButton(
                                  onPressed: () {
                                    moveBackward();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                )
                              : Container(),
                        )
                      : Container(),
                  const Spacer(),
                  Container(
                    height: 140,
                    width: 50,
                    color: Colors.black.withOpacity(0.3),
                    child: listSelected
                        ? IconButton(
                            onPressed: () {
                              moveForward();
                            },
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                          )
                        : Container(),
                  ),
                ],
              )),
        ),
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
            child: const SizedBox(
              width: 1360,
              height: 185,
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
                setState(() {
                  listSelected = true;
                });
              },
              onExit: (event) {
                Future.delayed(const Duration(seconds: 20)).then(
                  (value) {
                    setState(() {
                      listSelected = false;
                    });
                  },
                );
              },
              child: const SizedBox(
                width: 1500,
                height: 140,
              ),
            )),
      ]),
    );
  }
}
