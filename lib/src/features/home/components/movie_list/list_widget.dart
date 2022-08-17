import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_list_controller.dart';

import 'package:vector_math/vector_math_64.dart' as vector;

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool textSelected = false;
  int value = 0;
  bool jump = false;
  @override
  void initState() {
    final controller = Modular.get<MovieListController>();
    controller.init();

    controller.addListener(() {
      setState(() {
        value = controller.current;
      });
    });

    Future.delayed(const Duration(seconds: 20)).then((value) {
      setState(() {
        jump = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 18,
            ));
    final controller = Modular.get<MovieListController>();
    List<Widget> widgets = controller.widgets.toList();

    if (value != 0) {
      widgets.insert(0, widgets[widgets.length - value]);
      widgets.removeAt(widgets.length - value);
    }
    return SizedBox(
      width: 1360,
      height: 450,
      child: Stack(children: [
        Positioned(
          top: 80,
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
                    )
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          transform:
              Matrix4.translation(vector.Vector3(jump ? -1320 : 0, 0, 0)),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: SizedBox(
                height: 500,
                width: controller.spacing * 12,
                child: Stack(children: widgets),
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
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
      ]),
    );
  }
}
