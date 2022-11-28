import 'package:flutter/material.dart';
import 'package:netflix/src/features/splash/components/icon_painter.dart';

class AppConsts {
  static const String placeholderJson = """{
            "title": "Breaking Bad",
            "backdrop": "assets/data/backdrops/breaking_bad_backdrop.jpg",
            "poster": "assets/data/posters/breaking_bad_poster.jpg",
            "rating": 98,
            "trailer": "assets/data/trailers/breaking_bad_trailer.mp4",
            "tags": [
                "Violentos",
                "Realistas",
                "Suspense"
            ],
            "age": 18,
            "detail": "5 temporadas",
            "logo": "assets/data/logos/breaking_bad_logo.png",
            "overview": "Quando Walter White, um professor de quimica no Novo Mexico, é diagnosticado"
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
