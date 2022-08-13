import 'package:flutter/material.dart';

abstract class VideoInterface {
  void init();
  void play();
  void seek(Duration position);
  void pause();
  void stop();
  void load(String id);
  void dispose();
  void defineThumbnail(String path);
  Widget frame();
}
