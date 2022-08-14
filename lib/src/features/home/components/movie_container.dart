import 'package:flutter/material.dart';

class MovieContainer extends StatefulWidget {
  final Color color;
  const MovieContainer({super.key, required this.color});

  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  bool isHover = false;
  bool hover = false;

  //TODO: Centralizar o widget e fazer ele para o canto esquerdo a cada 5 widgets
  //TODO: Terminar Barra de cima

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeIn;
  static const delay = Duration(milliseconds: 400);
  static const double width = 260;
  static const double height = 140;
  static const double factor = 1.45;
  static const double infoHeight = width * factor - height * factor - 40;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: curve,
      duration: duration,
      height: hover ? height * factor + infoHeight : height * factor + 40,
      width: hover ? width * factor : width,
      padding: EdgeInsets.only(
        top: hover ? 0 : 60,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {},
        onHover: (v) {
          Future.delayed(delay).then((value) {
            setState(() {
              hover = v;
            });
          });
        },
        child: Stack(
          children: [
            AnimatedContainer(
              curve: curve,
              duration: duration,
              width: hover ? width * factor : width,
              height: hover ? height * factor : height,
              color: widget.color,
            ),
            AnimatedContainer(
              margin: EdgeInsets.only(
                top: hover ? height * factor - 1 : height - 1,
              ),
              curve: curve,
              duration: duration,
              height: hover ? infoHeight : 0,
              width: hover ? width * factor : width,
              color: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
  }
}
