import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:dart_vlc/dart_vlc.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _isOnline = false;
  bool _enableFrame = false;
  bool _isPlaying = true;
  String path = '';
  int id = 0;
  late Player _controller;
  double width = 1360;
  double height = 768;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 2);
  List<Media> medias = <Media>[];
  Player get controller => _controller;

  PlayerImpl({required this.id}) {
    _controller = Player(
      id: id,
      videoDimensions: const VideoDimensions(640, 360),
    );
  }

  @override
  Widget frame() {
    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    if (_enableFrame) {
      return Video(
        player: _controller,
        width: width,
        height: height,
        showControls: false,
      );
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
    _controller.playbackStream.listen((event) {
      _isPlaying = event.isPlaying;
      callback?.call();
    });
    _controller.positionStream.listen((event) {
      if (event.position != null) {
        _position = event.position!;
        positionStream?.call(_position);
        callback?.call();
      }

      if (event.duration != null) {
        _duration = event.duration!;
        callback?.call();
      }
    });
    load(video, callback: callback);
    path = video;
    width = w;
    height = h;
  }

  @override
  void load(String id, {void Function()? callback}) {
    medias.add(_isOnline ? Media.network(id) : Media.asset(id));
    _controller.open(
        Playlist(
          medias: medias,
        ),
        autoStart: false);
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
    _controller.seek(position);
  }

  @override
  void stop() {
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    return _controller.general.volume;
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume(volume);
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
    _controller.setRate(speed);
  }

  @override
  Widget slider(EdgeInsets padding) {
    throw UnimplementedError();
  }
}
