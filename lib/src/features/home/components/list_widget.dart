import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/src/features/home/components/movie_container.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool textSelected = false;
  final Random _random = Random(6699);
  final double spacing = 250;
  List<Widget> widgets = [];

  @override
  void initState() {
    for (int i = 12; i >= 0; i--) {
      widgets.add(Positioned(
        left: spacing * i,
        child: MovieContainer(
            color: Color.fromRGBO(
          _random.nextInt(255),
          _random.nextInt(255),
          _random.nextInt(255),
          1,
        )),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 18,
            ));

    return SizedBox(
      width: 1360,
      height: 350,
      child: ElevatedButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0)),
        onHover: (v) {
          setState(() {
            textSelected = v;
          });
        },
        onPressed: () {},
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 40,
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
            Positioned(
                left: 25,
                child: SizedBox(
                    height: 500,
                    width: spacing * 12,
                    child: Stack(children: widgets))),
          ],
        ),
      ),
    );
  }
}
