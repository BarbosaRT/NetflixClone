import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/player/player_page.dart';

class SpeedWidget extends StatefulWidget {
  final VideoInterface videoController;
  const SpeedWidget({super.key, required this.videoController});

  @override
  State<SpeedWidget> createState() => _SpeedWidgetState();
}

class _SpeedWidgetState extends State<SpeedWidget> {
  bool _speedHover = false;

  static const Duration duration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final colorController = Modular.get<ColorController>();
    final TextStyle headline2 = AppFonts().headline4.copyWith(fontSize: 24);
    return HoverWidget(
      useNotification: false,
      delayOut: Duration.zero,
      fadeDuration: Duration.zero,
      type: HoverType.top,
      rightPadding: 150,
      maxWidth: 650,
      maxHeight: 300,
      distance: 180,
      onHover: () {
        if (!_speedHover) {
          setState(() {
            _speedHover = true;
          });
        }
      },
      onExit: () {
        setState(() {
          _speedHover = false;
        });
      },
      icon: AnimatedScale(
          scale: _speedHover ? 1.25 : 1,
          duration: duration,
          child: const Icon(Icons.speed, color: Colors.white, size: 45)),
      child: Container(
          width: 650,
          height: 170,
          color: colorController.currentScheme.likeButtonColor,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Text('Velocidade De Reprodução', style: headline2),
              ),
              Positioned(
                top: 30,
                child: SizedBox(
                  width: 650,
                  height: 130,
                  child: Stack(
                    children: [
                      Container(
                        width: 650,
                        height: 120,
                        alignment: Alignment.center,
                        child: Container(
                          width: 530,
                          height: 2,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Row(
                        children: [
                          for (int o = 2; o <= 6; o++)
                            SpeedButton(
                              speed: o / 4,
                              videoController: widget.videoController,
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class SpeedButton extends StatefulWidget {
  final double speed;
  final VideoInterface videoController;
  const SpeedButton(
      {super.key, required this.speed, required this.videoController});

  @override
  State<SpeedButton> createState() => _SpeedButtonState();
}

class _SpeedButtonState extends State<SpeedButton> {
  bool clicked = false;

  @override
  void initState() {
    final speedController = Modular.get<PlayerNotifier>();
    speedController.addListener(() {
      if (mounted) {
        setState(() {
          clicked = speedController.getSpeed() == widget.speed;
        });
      }
    });
    clicked = speedController.getSpeed() == widget.speed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final speedController = Modular.get<PlayerNotifier>();
    final TextStyle headline = AppFonts().headline4.copyWith(fontSize: 20);
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.likeButtonColor;
    return SizedBox(
      width: 130,
      height: 130,
      child: GestureDetector(
          onTap: () {
            widget.videoController.changeSpeed(widget.speed);
            speedController.changeSpeed(widget.speed);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                width: 130,
                height: 40,
                alignment: Alignment.center,
                child: clicked
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 3),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.circle,
                            color: Colors.white, size: 25),
                      )
                    : const Icon(Icons.circle, color: Colors.grey, size: 20),
              ),
              Container(
                width: 130,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    '${widget.speed}x ${widget.speed == 1.0 ? "Normal" : ""}',
                    style: headline),
              ),
            ],
          )),
    );
  }
}
