import 'dart:io';

import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:dart_vlc/dart_vlc.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _enableFrame = true;
  bool _isPlaying = true;
  String path = '';
  final Player _controller = Player(
    id: 0,
    videoDimensions: const VideoDimensions(640, 360),
    registerTexture: !Platform.isWindows,
  );
  double width = 1360;
  double height = 768;

  List<Media> medias = <Media>[];
  Player get controller => _controller;

  @override
  Widget frame() {
    print('PRINT: $_enableFrame, ${isPlaying()}');
    if (_enableFrame && _isPlaying) {
      return !Platform.isWindows
          ? Video(
              player: _controller,
              width: width,
              height: height,
              showControls: false,
            )
          : NativeVideo(player: _controller, height: height, width: width);
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
      {double w = 1360, double h = 768, void Function()? callback}) {
    // _controller = Player(
    //   id: video.length,
    //   videoDimensions: const VideoDimensions(1360, 768),
    //   registerTexture: !Platform.isWindows,
    // );
    //
    _controller.playbackStream.listen((event) {
      _isPlaying = event.isPlaying;
      callback?.call();
    });
    load(video, callback: callback);
    path = video;
    width = w;
    height = h;
  }

  @override
  void load(String id, {void Function()? callback}) {
    medias.add(Media.asset(id));
    _controller.open(
        Playlist(
          medias: medias,
          playlistMode: PlaylistMode.single,
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
    dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  bool isPlaying() {
    return _isPlaying;
  }

  @override
  void enableFrame(bool enable) {
    _enableFrame = true;
  }

  @override
  void defineThumbnail(String path) {
    _thumbnail = path;
  }

  @override
  double getVolume() {
    return _controller.general.volume;
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume(volume);
  }
}
