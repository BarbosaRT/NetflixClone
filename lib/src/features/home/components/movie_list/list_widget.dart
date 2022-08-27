import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_list_controller.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool textSelected = false;
  bool listSelected = false;

  double movingValue = 1254;
  final ScrollController _scrollController = ScrollController();
  // A movie list is divided in 5 parts (when showing) this is an Index that shows the current part
  double selectedIndex = 1;

  static const duration = Duration(milliseconds: 500);

  List<Widget> widgets = [];

  static const double distanceToTop = 90;

  @override
  void initState() {
    super.initState();

    final controller = Modular.get<MovieListController>();

    controller.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widgets = controller.widgets.toList();
        _scrollController.jumpTo(movingValue);
      });
      controller.addListener(() {
        widgetController();
      });
    });
  }

  void move() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
          movingValue * selectedIndex + 5 * selectedIndex,
          duration: duration,
          curve: Curves.easeInOut);
    });
  }

  void moveForward() {
    final controller = Modular.get<MovieListController>();
    if (selectedIndex >= controller.movies ~/ 5) {
      final secondDuration =
          Duration(milliseconds: duration.inMilliseconds + 200);
      move();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(secondDuration).then(
          (value) => {
            setState(
              () {
                selectedIndex = 1;
                _scrollController.jumpTo(
                  movingValue * selectedIndex,
                );
              },
            ),
          },
        );
      });
    } else {
      move();
    }

    selectedIndex += 1;
    controller.enableLeft();
  }

  void moveBackward() {
    final controller = Modular.get<MovieListController>();
    if (selectedIndex <= 0) {
      selectedIndex = (controller.movies ~/ 5).toDouble();

      final secondDuration =
          Duration(milliseconds: duration.inMilliseconds + 100);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(0,
            duration: duration, curve: Curves.easeInOut);

        Future.delayed(secondDuration).then((value) {
          setState(() {
            _scrollController.jumpTo(
              movingValue * selectedIndex,
            );
          });
        });
      });
    } else {
      move();
      selectedIndex -= 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void widgetController() {
    final controller = Modular.get<MovieListController>();
    setState(() {
      widgets = controller.widgets.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<MovieListController>();
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
                'Porque você viu Meu Malvado Favorito 2',
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
                    for (int i = 0; i < (controller.movies) ~/ 5; i++)
                      Container(
                        width: 13,
                        height: 2,
                        color: i == selectedIndex - 1
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
                  controller.enabledLeft
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
