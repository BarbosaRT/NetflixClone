import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeImpl implements VideoInterface {
  String _thumbnail = '';
  double width = 1360;
  double height = 768;
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '65yL42CwR8Q',
    params: const YoutubePlayerParams(
      startAt: Duration(seconds: 0),
      enableJavaScript: false,
      desktopMode: true,
      showControls: false,
      showVideoAnnotations: false,
      showFullscreenButton: false,
    ),
  );

  @override
  void init(String video,
      {double w = 1360,
      double h = 768,
      void Function()? callback,
      void Function(Duration position)? positionStream}) async {
    await Future.delayed(const Duration(seconds: 2));
    width = w;
    height = h;
    play();
  }

  @override
  void load(String videoId, {void Function()? callback}) {
    _controller.load(videoId);
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
  void enableFrame(bool enable) {
    return;
  }

  @override
  void seek(Duration position) {
    _controller.seekTo(position);
  }

  @override
  bool isPlaying({bool? enable}) {
    return enable ?? _controller.value.hasPlayed;
  }

  @override
  void stop() {
    _controller.stop();
  }

  @override
  Widget frame() {
    return _controller.value.hasPlayed
        ? YoutubePlayerIFrame(
            controller: _controller,
            aspectRatio: 16 / 9,
          )
        : _thumbnail.isEmpty
            ? Container(width: 5, height: 5, color: Colors.transparent)
            : SizedBox(
                width: width,
                height: height,
                child: Image.asset(_thumbnail, fit: BoxFit.cover));
  }

  @override
  void dispose() {}

  @override
  void defineThumbnail(String path) {
    _thumbnail = path;
  }

  @override
  double getVolume() {
    return -1;
  }

  @override
  void setVolume(double volume) {}

  @override
  Duration getPosition() {
    return _controller.value.position;
  }

  @override
  Duration getDuration() {
    return _controller.metadata.duration;
  }

  @override
  void changeSpeed(double speed) {
    _controller.setPlaybackRate(speed);
  }

  @override
  Widget slider(EdgeInsets padding) {
    throw UnimplementedError();
  }
}
