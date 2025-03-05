import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _isOnline = false;
  bool _enableFrame = false;
  bool _isPlaying = true;
  String path = '';
  int id = 0;
  late Player _player;
  double width = 1360;
  double height = 768;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 2);
  List<Media> medias = <Media>[];
  Player get player => _player;
  late VideoController _controller;

  PlayerImpl({required this.id}) {
    _player = Player();
    _controller = VideoController(_player);
  }

  @override
  Widget frame() {
    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    if (_enableFrame) {
      return Video(
          controller: _controller,
          width: width,
          height: height,
          controls: NoVideoControls);
    } else {
      return _thumbnail.isEmpty
          ? Container()
          : SizedBox(
              width: width,
              height: height,
              child: Image(image: image, fit: BoxFit.cover));
    }
  }

  @override
  void init(String video,
      {double w = 1360,
      double h = 768,
      void Function()? callback,
      void Function(Duration position)? positionStream,
      bool? isOnline}) {
    if (isOnline != null) {
      _isOnline = isOnline;
    }
    _player.stream.playing.listen((bool playing) {
      _isPlaying = playing;
      callback?.call();
    });

    _player.stream.duration.listen((Duration duration) {
      _duration = duration;
      callback?.call();
    });

    _player.stream.position.listen((Duration position) {
      _position = position;
      positionStream?.call(_position);
      callback?.call();
    });
    load(video, callback: callback);
    path = video;
    width = w;
    height = h;
  }

  @override
  void load(String id, {void Function()? callback}) {
    medias.add(Media(id));
    _player.open(Playlist(medias), play: false);
  }

  @override
  void pause() {
    _player.pause();
  }

  @override
  void play() {
    _player.play();
  }

  @override
  void seek(Duration position) {
    _player.seek(position);
  }

  @override
  void stop() {
    _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
  }

  @override
  bool isPlaying({bool? enable}) {
    _isPlaying = enable ?? _isPlaying;
    return _isPlaying;
  }

  @override
  void enableFrame(bool enable) {
    _enableFrame = enable;
  }

  @override
  void defineThumbnail(String path, bool isOnline) {
    _thumbnail = path;
    _isOnline = isOnline;
  }

  @override
  double getVolume() {
    return _player.state.volume / 100;
  }

  @override
  void setVolume(double volume) {
    _player.setVolume(volume * 100);
  }

  @override
  Duration getPosition() {
    if (_position.inSeconds > 0 && _position < getDuration()) {
      return _position;
    }
    return Duration.zero;
  }

  @override
  Duration getDuration() {
    return _duration;
  }

  @override
  void changeSpeed(double speed) {
    _player.setRate(speed);
  }

  @override
  Widget slider(EdgeInsets padding) {
    throw UnimplementedError();
  }
}
