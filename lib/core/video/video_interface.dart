import 'package:flutter/material.dart';

abstract class VideoInterface {
  void init(String video);
  void play();
  void seek(Duration position);
  void pause();
  void stop();
  void load(String id);
  void dispose();
  void defineThumbnail(String path);
  double getVolume();
  void setVolume(double volume);
  Widget frame();
}
