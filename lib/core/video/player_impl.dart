import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:video_player/video_player.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _enableFrame = true;
  String path = '';
  late VideoPlayerController _controller;
  double width = 1360;
  double height = 768;
  VideoPlayerController get controller => _controller;

  @override
  Widget frame() {
    if (_controller.value.isInitialized && _enableFrame && isPlaying()) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return _thumbnail.isEmpty
          ? Container()
          : SizedBox(
              width: width,
              height: height,
              child: Image.asset(_thumbnail, fit: BoxFit.cover));
    }
  }

  @override
  void init(String video, {double w = 1360, double h = 768}) {
    load(video);
    path = video;
    width = w;
    height = h;
    // _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')..initialize();
  }

  @override
  void load(String id) {
    _controller = VideoPlayerController.asset(id)..initialize();
  }

  @override
  void pause() {
    _controller.pause();
  }

  @override
  void play() {
    _controller.play();
  }

  @override
  void seek(Duration position) {
    _controller.seekTo(position);
  }

  @override
  void stop() {
    dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  bool isPlaying() {
    return _controller.value.isPlaying;
  }

  void enableFrame(bool enable) {
    _enableFrame = enable;
  }

  @override
  void defineThumbnail(String path) {
    _thumbnail = path;
  }

  @override
  double getVolume() {
    return _controller.value.volume;
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume(volume);
  }
}
