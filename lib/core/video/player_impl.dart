import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:video_player/video_player.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _enableFrame = false;
  String path = '';
  late VideoPlayerController _controller;
  double width = 1360;
  double height = 768;
  bool _isInitialized = false;
  VideoPlayerController get controller => _controller;
  int id = 0;

  PlayerImpl({required this.id});

  @override
  Widget frame() {
    if (_isInitialized && _enableFrame && isPlaying()) {
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
  void init(String video,
      {double w = 1360,
      double h = 768,
      void Function()? callback,
      void Function(Duration position)? positionStream}) {
    load(video, callback: callback, positionStream: positionStream);
    path = video;
    width = w;
    height = h;
    // _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')..initialize();
  }

  @override
  void load(String id,
      {void Function()? callback,
      void Function(Duration position)? positionStream}) {
    Future.delayed(
      const Duration(milliseconds: 1000),
    );
    _controller = VideoPlayerController.asset(id)
      ..initialize().then((value) {
        _isInitialized = true;
        if (callback != null) {
          callback.call();
        }
      });
    _controller.addListener(
      () {
        positionStream?.call(controller.value.position);
        if (controller.value.position == controller.value.duration) {
          enableFrame(false);
        }
        if (_controller.value.isPlaying && !_enableFrame) {
          Future.delayed(const Duration(milliseconds: 1000)).then(
            (value) {
              if (callback != null) {
                callback.call();
              }
              enableFrame(true);
            },
          );
        }
      },
    );
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

  @override
  bool isPlaying({bool? enable}) {
    return enable ?? _controller.value.isPlaying;
  }

  @override
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

  @override
  Duration getPosition() {
    if (!_isInitialized) {
      return const Duration(seconds: 1);
    }
    return _controller.value.position;
  }

  @override
  Duration getDuration() {
    if (!_isInitialized) {
      return const Duration(seconds: 2);
    }
    return _controller.value.duration;
  }

  @override
  void changeSpeed(double speed) {
    if (_isInitialized) {
      _controller.setPlaybackSpeed(speed);
    }
  }
}
