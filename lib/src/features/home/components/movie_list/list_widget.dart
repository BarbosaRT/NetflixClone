import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_container.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_list_controller.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool textSelected = false;
  bool listSelected = false;

  int value = 0;

  double movingValue = 1350;
  final ScrollController _scrollController = ScrollController();
  // A movie list is divided in 5 parts (when showing) this is an Index that shows the current part
  double selectedIndex = 0;
  bool allowLeft = false;

  List<Widget> widgets = [];

  static const double distanceToTop = 90;

  @override
  void initState() {
    super.initState();

    final controller = Modular.get<MovieListController>();

    controller.init();
    controller.addListener(() {
      widgetController();
    });

    setState(() {
      widgets = controller.test.toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void widgetController() {
    final controller = Modular.get<MovieListController>();
    if (value == controller.current) {
      return;
    }
    value = controller.current;
    widgets = controller.test.toList();
    Duration duration = const Duration(milliseconds: 300);
    if (controller.getAnchor(value) == MovieContainerAnchor.center) {
      //
      Future.delayed(duration).then((v) {
        widgets.insert(0, widgets[widgets.length - value]);
        widgets.removeAt(widgets.length - value);
        setState(() {});
      });
      //
    } else if (controller.getAnchor(value) == MovieContainerAnchor.right) {
      Future.delayed(duration).then((v) {
        widgets = widgets.reversed.toList();
        setState(() {});
      });
    } else {
      Future.delayed(duration).then((v) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<MovieListController>();
    final width = MediaQuery.of(context).size.width;
    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 18,
            ));

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
                'Porque você viu Meu Malvado Favorito 2 ${controller.current}',
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
                    for (int i = 0; i < 5; i++)
                      Container(
                        width: 13,
                        height: 2,
                        color: i == selectedIndex
                            ? Colors.grey
                            : Colors.grey.shade800,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
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
              width: 1360,
              height: 140,
              child: Row(
                children: [
                  allowLeft
                      ? Container(
                          height: 140,
                          width: 50,
                          color: Colors.black.withOpacity(0.4),
                          child: listSelected
                              ? IconButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _scrollController.animateTo(
                                          movingValue * selectedIndex,
                                          duration: const Duration(seconds: 2),
                                          curve: Curves.linear);
                                    });
                                    selectedIndex -= 1;
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
                    color: Colors.black.withOpacity(0.4),
                    child: listSelected
                        ? IconButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollController.animateTo(
                                    movingValue * selectedIndex,
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.linear);
                              });
                              selectedIndex += 1;
                              setState(() {
                                allowLeft = true;
                              });
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
