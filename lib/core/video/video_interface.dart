import 'package:flutter/material.dart';

abstract class VideoInterface {
  void init(String video,
      {double w = 1360,
      double h = 768,
      void Function()? callback,
      void Function(Duration position)? positionStream,
      bool? isOnline});
  void play();
  void seek(Duration position);
  void pause();
  void stop();
  void load(String id, {void Function()? callback});
  void dispose();
  void defineThumbnail(String path, bool isOnline);
  double getVolume();
  void setVolume(double volume);
  void enableFrame(bool enable);
  bool isPlaying({bool? enable});
  Duration getPosition();
  Duration getDuration();
  void changeSpeed(double speed);
  void changeSize(double w, double h);
  Widget frame();
  Widget slider(EdgeInsets padding);
}
