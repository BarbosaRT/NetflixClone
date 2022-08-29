import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:video_player/video_player.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _enableFrame = true;
  late VideoPlayerController _controller;
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
          ? Container(width: 5, height: 5, color: Colors.red)
          : Image.asset(_thumbnail);
    }
  }

  @override
  void init() {
    load('assets/videos/Minions.mp4');
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
