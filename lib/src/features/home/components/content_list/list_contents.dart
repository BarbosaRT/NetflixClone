import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/content_list/content_list_widget.dart';

enum ContentListAnchor { top, middle, bottom }

class ListContents extends StatefulWidget {
  const ListContents({super.key});

  @override
  State<ListContents> createState() => _ListContentsState();
}

class _ListContentsState extends State<ListContents> {
  static const Duration duration = Duration(milliseconds: 300);
  static const double spacing = 220.0;
  int current = 0;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];

  static const List<String> titles = [
    'Porque você viu Meu Malvado Favorito 2',
    'Mais de Comedia',
    'Top em Alta no Brasil',
    'Porque você viu Smurfs',
    'Filmes Coreanos',
    'Mais de Terror',
  ];
  static List<CarouselController> controllers = [
    CarouselController(),
    CarouselController(),
    CarouselController(),
    CarouselController(),
    CarouselController(),
    CarouselController(),
  ];
  static const listCount = 6;

  @override
  void initState() {
    widgetBuilder();
    super.initState();
  }

  ContentListAnchor getAnchorFromValue(int index) {
    switch (index) {
      case 0:
        return ContentListAnchor.top;
      case listCount - 1:
        return ContentListAnchor.bottom;
      default:
        return ContentListAnchor.middle;
    }
  }

  void widgetBuilder() {
    for (int i = listCount - 1; i >= 0; i--) {
      widgets.add(
        Positioned(
          top: spacing * i,
          child: ContentListWidget(
            index: i,
            title: titles[i],
            anchor: getAnchorFromValue(i),
            onHover: () {
              onHover(i);
            },
            controller: controllers[i],
          ),
        ),
      );
    }
    oldWidgets = widgets.toList();
  }

  void onHover(int index) {
    if (current == index) {
      return;
    }
    current = index;
    switch (getAnchorFromValue(index)) {
      case ContentListAnchor.middle:
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
      case ContentListAnchor.top:
        Future.delayed(duration).then((v) {
          if (mounted) {
            setState(() {
              widgets = oldWidgets.toList();
            });
          }
        });
        break;
      case ContentListAnchor.bottom:
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
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 4000,
      child: Stack(
        children: widgets,
      ),
    );
  }
}
