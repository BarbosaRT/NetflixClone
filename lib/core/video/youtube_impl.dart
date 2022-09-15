import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeImpl implements VideoInterface {
  String _thumbnail = '';

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
  void init(String video) async {
    await Future.delayed(const Duration(seconds: 2));
    play();
  }

  @override
  void load(String videoId) {
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
  void seek(Duration position) {
    _controller.seekTo(position);
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
            ? Image.asset(_thumbnail)
            : Container(width: 5, height: 5, color: Colors.red);
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
}
