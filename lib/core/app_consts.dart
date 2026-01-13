import 'package:flutter/material.dart';
import 'package:oldflix/src/features/splash/components/icon_painter.dart';

class AppConsts {
  static const String placeholderJson = """{
            "title": "Wuthering Heights",
            "backdrop": "assets/data/backdrops/wuthering_heights_backdrop.jpg",
            "poster": "assets/data/posters/wuthering_heights_poster.png",
            "rating": 98,
            "trailer": "assets/data/trailers/wuthering_heights_trailer.mp4",
            "tags": [
                "Romance",
                "Realistas",
                "Suspense"
            ],
            "age": 0,
            "detail": "1h 44min",
            "logo": "assets/data/logos/wuthering_heights_logo.png",
            "overview": "After her parents die, Cathy and Heathcliff grow up wild and free on the moors and despite the continued enmity between Hindley and Heathcliff they're happy -- until Cathy meets Edgar Linton, the son of a wealthy neighbor."
        }""";
  static const Map<int, String> classifications = {
    0: 'assets/images/classifications/L.png',
    10: 'assets/images/classifications/10.png',
    12: 'assets/images/classifications/12.png',
    14: 'assets/images/classifications/14.png',
    16: 'assets/images/classifications/16.png',
    18: 'assets/images/classifications/18.png',
  };

  dynamic getImage(String poster, bool isOnline) {
    return isOnline ? NetworkImage(poster) : AssetImage(poster);
  }

  Size getTextSize(String text, TextStyle style) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter.size;
  }

  Widget createIcon(Path path, Color color, Size size) {
    return CustomPaint(
      painter: IconPainter(
        path: path,
        color: color,
      ),
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.transparent,
      ),
    );
  }
}
