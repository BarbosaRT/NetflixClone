import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/smooth_scroll.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  late GlobalKey _scaffoldKey;
  MyGlobals() {
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

  static const transitionDuration = Duration(milliseconds: 300);
  final ValueNotifier<bool> _active = ValueNotifier(false);
  final height = 2000.0;

  @override
  void initState() {
    super.initState();
    _active.value = false;
    Future.delayed(transitionDuration).then(
      (value) {
        _active.value = true;
      },
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _active.value = false;
          Modular.to.navigate('/home');
        },
        child: const Icon(Icons.read_more),
      ),
      key: myGlobals.scaffoldKey,
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
                          SizedBox(
                            width: width,
                            height: height,
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 50),
                              width: width - 400,
                              height: height,
                              color: backgroundColor,
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  title,
                                  style: headline3,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Positioned(
                            left: width - 13,
                            child: Container(
                              width: 15,
                              height: height,
                              color: value ? Colors.white : Colors.transparent,
                            ),
                          ),
                        ]),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
