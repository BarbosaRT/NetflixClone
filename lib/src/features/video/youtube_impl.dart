import 'package:flutter/material.dart';
import 'package:netflix/src/features/video/video_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeImpl implements VideoInterface {
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
  void init() async {
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
    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }

  @override
  void dispose() {}
}
