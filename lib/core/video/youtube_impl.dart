import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeImpl implements VideoInterface {
  String _thumbnail = '';
  bool _isOnline = false;
  double width = 1360;
  double height = 768;
  bool _enableFrame = true;
  YoutubePlayerController _controller = YoutubePlayerController(
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
      void Function(Duration position)? positionStream,
      bool? isOnline}) async {
    _controller = YoutubePlayerController(
      initialVideoId: video.replaceAll('https://yewtu.be/watch?v=', ''),
      params: const YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        enableJavaScript: false,
        desktopMode: true,
        showControls: false,
        showVideoAnnotations: false,
        showFullscreenButton: false,
      ),
    );
    // load(video, callback: callback);
    width = w;
    height = h;
    play();
  }

  @override
  void load(String videoId, {void Function()? callback}) {
    _controller
        .load(videoId.replaceAll('https://www.youtube.com/watch?v=', ''));
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
    _enableFrame = enable;
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
    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    return _enableFrame
        ? SizedBox(
            width: width,
            height: height,
            child: YoutubePlayerIFrame(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          )
        : _thumbnail.isEmpty
            ? Container(width: 5, height: 5, color: Colors.transparent)
            : SizedBox(
                width: width,
                height: height,
                child: Image(image: image, fit: BoxFit.cover));
  }

  @override
  void dispose() {}

  @override
  void defineThumbnail(String path, bool isOnline) {
    _thumbnail = path;
    _isOnline = isOnline;
  }

  @override
  double getVolume() {
    return _controller.value.volume / 100;
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume((volume * 100).toInt());
  }

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
