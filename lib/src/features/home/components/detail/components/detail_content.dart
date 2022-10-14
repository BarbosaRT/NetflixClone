import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';

class DetailContent extends StatefulWidget {
  final ContentModel content;
  const DetailContent({super.key, required this.content});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  final ValueNotifier<bool> _isHover = ValueNotifier(false);
  ValueNotifier<bool> added = ValueNotifier(false);

  void onExit() {
    _isHover.value = false;
  }

  void onHover() {
    _isHover.value = true;
  }

  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.containerColor3;

    final headline = AppFonts().headline6;
    final headline2 = AppFonts()
        .headline8
        .copyWith(color: const Color.fromRGBO(190, 190, 190, 1));

    return SizedBox(
        width: 300,
        height: 360,
        child: Stack(
          children: [
            Container(
              width: 236,
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
            ),
            Container(
              width: 236,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                  image: AssetImage(widget.content.poster),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _isHover,
              builder: (context, bool value, child) {
                return Container(
                  width: 236,
                  height: 140,
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: value ? 1 : 0,
                    child: const Icon(Icons.play_arrow,
                        size: 50, color: Colors.white),
                  ),
                );
              },
            ),
            //
            // Details
            //
            Positioned(
              left: 116,
              child: Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0),
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.content.detail.replaceAll('temporada', 'parte'),
                      style: headline2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
            //
            // Info
            //
            Positioned(
              top: 160,
              child: Row(
                children: [
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            '61% Relevante',
                            style: headline.copyWith(color: Colors.green),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Image.asset(
                                AppConsts.classifications[widget.content.age] ??
                                    'assets/images/classifications/L.png',
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                ' 2020',
                                style: headline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 220,
              left: 17,
              child: SizedBox(
                width: 220,
                child: Text(
                  widget.content.overview,
                  style: headline2,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 70,
              child: ContentButton(
                  onClick: () {
                    added.value = !added.value;
                  },
                  text: ValueListenableBuilder(
                    valueListenable: added,
                    builder: (BuildContext context, bool value, child) {
                      return Text(
                        value
                            ? 'Remover da Minha lista'
                            : 'Adicionar à Minha lista',
                        textAlign: TextAlign.center,
                        style: headline.copyWith(color: Colors.black),
                      );
                    },
                  ),
                  icon: ValueListenableBuilder(
                    valueListenable: added,
                    builder: (BuildContext context, bool value, child) {
                      return Icon(
                        value ? Icons.done : Icons.add,
                        size: 25,
                        color: Colors.white,
                      );
                    },
                  )),
            ),
            HoverWidget(
              useNotification: false,
              delayOut: Duration.zero,
              fadeDuration: Duration.zero,
              maxWidth: 236,
              maxHeight: 360,
              rightPadding: 236,
              detectChildArea: false,
              onExit: onExit,
              onHover: onHover,
              icon: const SizedBox(
                width: 236,
                height: 360,
              ),
            )
          ],
        ));
  }
}
