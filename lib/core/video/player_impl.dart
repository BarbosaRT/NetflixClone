import 'package:flutter/material.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:video_player/video_player.dart';

class PlayerImpl implements VideoInterface {
  String _thumbnail = '';
  bool _isOnline = false;
  bool _enableFrame = false;
  String path = '';
  VideoPlayerController? _controller;
  double _width = 1360;
  double _height = 768;
  bool _isInitialized = false;
  bool _isDisposed = false;
  VideoPlayerController? get controller => _controller;
  int id = 0;

  PlayerImpl({required this.id});

  @override
  void changeSize(double width, double height) {
    _width = width;
    _height = height;
  }

  @override
  Widget frame() {
    if (_isDisposed || _controller == null) {
      dynamic image =
          _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
      return _thumbnail.isEmpty
          ? Container()
          : SizedBox(
              width: _width,
              height: _height,
              child: Image(image: image, fit: BoxFit.cover));
    }

    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    if (_isInitialized && _enableFrame && _controller != null) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return _thumbnail.isEmpty
          ? Container()
          : SizedBox(
              width: _width,
              height: _height,
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
    if (_isDisposed) return;

    if (isOnline != null) {
      _isOnline = isOnline;
    }
    load(video, callback: callback, positionStream: positionStream);
    path = video;
    _width = w;
    _height = h;
  }

  @override
  void load(String id,
      {void Function()? callback,
      void Function(Duration position)? positionStream}) {
    if (_isDisposed) return;

    Future.delayed(const Duration(seconds: 1));
    if (_isOnline) {
      _controller = VideoPlayerController.networkUrl(Uri(path: id))
        ..initialize().then((value) {
          if (!_isDisposed) {
            _isInitialized = true;
            if (callback != null) {
              callback.call();
            }
          }
        });
    } else {
      _controller = VideoPlayerController.asset(id)
        ..initialize().then((value) {
          if (!_isDisposed) {
            _isInitialized = true;
            if (callback != null) {
              callback.call();
            }
          }
        });
    }

    if (_controller != null) {
      _controller!.addListener(
        () {
          if (_isDisposed || _controller == null) return;

          positionStream?.call(_controller!.value.position);
          if (_controller!.value.position == _controller!.value.duration) {
            enableFrame(false);
          }
          if (_controller!.value.isPlaying && !_enableFrame) {
            Future.delayed(const Duration(milliseconds: 1000)).then(
              (value) {
                if (!_isDisposed && callback != null) {
                  callback.call();
                }
                if (!_isDisposed) {
                  enableFrame(true);
                }
              },
            );
          }
        },
      );
    }
  }

  @override
  Widget slider(EdgeInsets padding) {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return Container();
    }
    return VideoProgressIndicator(
      _controller!,
      allowScrubbing: true,
      padding: padding,
    );
  }

  @override
  void pause() {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return;
    }
    _controller!.pause();
  }

  @override
  void play() {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return;
    }
    _controller!.play();
  }

  @override
  void seek(Duration position) async {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return;
    }
    await _controller!.seekTo(position);
  }

  @override
  void stop() {
    dispose();
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (!_isInitialized || _controller == null) {
      return;
    }
    try {
      _controller!.dispose();
      _controller = null;
    } catch (e) {
      // ignore: avoid_print
      print('Error disposing video controller: $e');
    }
  }

  @override
  bool isPlaying({bool? enable}) {
    if (_isDisposed || _controller == null) return false;
    return enable ?? _controller!.value.isPlaying;
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
    if (!_isInitialized || _isDisposed || _controller == null) {
      return 1.0;
    }
    return _controller!.value.volume;
  }

  @override
  void setVolume(double volume) {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return;
    }
    _controller!.setVolume(volume);
  }

  @override
  Duration getPosition() {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return const Duration(seconds: 1);
    }
    return _controller!.value.position;
  }

  @override
  Duration getDuration() {
    if (!_isInitialized || _isDisposed || _controller == null) {
      return const Duration(seconds: 2);
    }
    return _controller!.value.duration;
  }

  @override
  void changeSpeed(double speed) {
    if (_isInitialized && !_isDisposed && _controller != null) {
      _controller!.setPlaybackSpeed(speed);
    }
  }
}
