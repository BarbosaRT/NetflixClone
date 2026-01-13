import 'package:flutter/material.dart';
import 'package:oldflix/core/video/video_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeImpl implements VideoInterface {
  String _thumbnail = '';
  bool _isOnline = false;
  double _width = 1360;
  double _height = 768;
  bool _enableFrame = true;
  YoutubePlayerController _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      enableJavaScript: false,
      showControls: false,
      showVideoAnnotations: false,
      showFullscreenButton: false,
    ),
  );
  @override
  void changeSize(double width, double height) {
    _width = width;
    _height = height;
  }

  @override
  void init(String video,
      {double w = 1360,
      double h = 768,
      void Function()? callback,
      void Function(Duration position)? positionStream,
      bool? isOnline}) async {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        enableJavaScript: false,
        showControls: false,
        showVideoAnnotations: false,
        showFullscreenButton: false,
      ),
    );
    // load(video, callback: callback);
    _width = w;
    _height = h;
    play();
  }

  @override
  void load(String videoId, {void Function()? callback}) {
    _controller.load(
      params: YoutubePlayerParams(
        origin: videoId.replaceAll('https://www.youtube.com/watch?v=', ''),
      ),
    );
  }

  @override
  void pause() {
    _controller.pauseVideo();
  }

  @override
  void play() {
    _controller.playVideo();
  }

  @override
  void enableFrame(bool enable) {
    _enableFrame = enable;
  }

  @override
  void seek(Duration position) {
    _controller.seekTo(seconds: position.inMilliseconds / 1000);
  }

  @override
  bool isPlaying({bool? enable}) {
    return enable ?? _controller.value.playerState == PlayerState.playing;
  }

  @override
  void stop() {
    _controller.stopVideo();
  }

  @override
  Widget frame() {
    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    return _enableFrame
        ? SizedBox(
            width: _width,
            height: _height,
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          )
        : _thumbnail.isEmpty
            ? Container(width: 5, height: 5, color: Colors.transparent)
            : SizedBox(
                width: _width,
                height: _height,
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
    return 1;
    // return (await _controller.volume) / 100;
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume((volume * 100).toInt());
  }

  @override
  Duration getPosition() {
    return Duration(seconds: _controller.metadata.duration.inSeconds - 1);
    //return Duration(seconds: (await _controller.currentTime).toInt());
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
