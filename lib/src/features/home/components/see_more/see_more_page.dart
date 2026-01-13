import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/core/api/content_controller.dart';
import 'package:oldflix/core/colors/color_controller.dart';
import 'package:oldflix/core/fonts/app_fonts.dart';
import 'package:oldflix/core/smooth_scroll.dart';
import 'package:oldflix/models/content_model.dart';
import 'package:oldflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:oldflix/src/features/home/components/content_list/list_contents.dart';

SeeMoreGlobals seeMoreGlobals = SeeMoreGlobals();

class SeeMoreGlobals {
  late GlobalKey _scaffoldKey;
  SeeMoreGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class SeeMorePage extends StatefulWidget {
  final String? title;
  const SeeMorePage({super.key, this.title = ''});

  @override
  State<SeeMorePage> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  final scrollController = ScrollController(initialScrollOffset: 0);
  static const listCount = 6;
  static const Duration duration = Duration(milliseconds: 300);
  static const transitionDuration = Duration(milliseconds: 300);
  final ValueNotifier<bool> _active = ValueNotifier(false);
  final height = 1680.0;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];
  static const double spacing = 220.0;
  int current = 0;

  @override
  void initState() {
    super.initState();
    widgetBuilder();
    _active.value = false;
    Future.delayed(transitionDuration).then(
      (value) {
        _active.value = true;
      },
    );
  }

  ContentListAnchor getAnchorFromValue(int index) {
    switch (index) {
      case 0:
        return ContentListAnchor.top;
      case const (listCount - 1):
        return ContentListAnchor.bottom;
      default:
        return ContentListAnchor.middle;
    }
  }

  void widgetBuilder() {
    for (int i = listCount - 1; i >= 0; i--) {
      widgets.add(
        Positioned(
          key: UniqueKey(),
          top: spacing * i,
          child: Builder(
            builder: (context) {
              final contentController = Modular.get<ContentController>();
              return StreamBuilder<List<ContentModel>>(
                stream: contentController
                    .getListContent(widget.title ?? 'Em Alta')
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  final List<ContentModel> contents = snapshot.data ??
                      contentController
                          .returnContentList(widget.title ?? 'Em Alta');

                  return ContentInnerWidget(
                    key: UniqueKey(),
                    id: widget.title ?? 'Em Alta',
                    index: i,
                    contents: contents,
                    contentCount: 5,
                    horizontalPadding: spacing,
                    onPlay: (bool value) {},
                    onHover: (bool _) {
                      onHover(i);
                    },
                    onDetail: (ContentModel content) {},
                  );
                },
              );
            },
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
    double width = MediaQuery.of(context).size.width;

    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    final headline3 = AppFonts().headline3;
    final title = widget.title ?? 'Em Alta';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: seeMoreGlobals.scaffoldKey,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        //
        child: ValueListenableBuilder(
          valueListenable: _active,
          builder: (context, bool value, child) {
            //
            return Scrollbar(
              trackVisibility: value,
              thumbVisibility: value,
              controller: scrollController,
              child: SmoothScroll(
                scrollSpeed: 90,
                scrollAnimationLength: 150,
                curve: Curves.decelerate,
                controller: scrollController,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        width: width,
                        height: height,
                        color: backgroundColor.withValues(alpha: 0.5),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 50),
                          width: width - 200,
                          height: height,
                          color: backgroundColor,
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: Text(
                              title,
                              style: headline3,
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Positioned(
                        left: 114,
                        top: 150,
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: Stack(
                            children: widgets,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: width - 190,
                        child: GestureDetector(
                          onTap: () {
                            _active.value = false;
                            Modular.to.navigate('/home');
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: _active.value
                                      ? Colors.transparent
                                      : Colors.white,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        left: width - 13,
                        child: Container(
                          width: 15,
                          height: height,
                          color: value ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
