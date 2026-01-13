import 'package:flutter/material.dart';
import 'package:oldflix/core/video/video_interface.dart';
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
  double _width = 1360;
  double _height = 768;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 2);
  List<Media> medias = <Media>[];
  Player get player => _player;
  late VideoController _controller;

  PlayerImpl({required this.id}) {
    _player = Player();
    _controller = VideoController(_player);
    //print("yeah");
  }

  @override
  void changeSize(double width, double height) {
    _width = width;
    _height = height;
  }

  @override
  Widget frame() {
    dynamic image =
        _isOnline ? NetworkImage(_thumbnail) : AssetImage(_thumbnail);
    if (_enableFrame) {
      return Video(
          controller: _controller,
          width: _width,
          height: _height,
          controls: NoVideoControls);
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
    _width = w;
    _height = h;
  }

  @override
  void load(String id, {void Function()? callback}) {
    try {
      // Stop current playback first
      _player.stop();
      // Clear previous media and add new one
      medias.clear();
      if (id.isNotEmpty) {
        medias.add(Media(id));
        _player.open(Playlist(medias), play: false);
      }
    } catch (e) {
      print('Error loading media: $e');
      // Reset to safe state
      medias.clear();
      _position = Duration.zero;
      _duration = const Duration(seconds: 1);
    }
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
    // Reset internal state
    _position = Duration.zero;
    _isPlaying = false;
    _enableFrame = false;
  }

  @override
  void dispose() {
    try {
      // Stop playback first
      _player.stop();
      // Clear media list safely
      medias.clear();
      // Reset state
      _position = Duration.zero;
      _duration = const Duration(seconds: 1);
      _isPlaying = false;
      _enableFrame = false;
      // Dispose the player
      _player.dispose();
    } catch (e) {
      print('Error disposing player: $e');
    }
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
    // Return safe position if no media is loaded or player is disposed
    try {
      if (medias.isEmpty || _player.state.playlist.medias.isEmpty) {
        return Duration.zero;
      }
      if (_position.inSeconds > 0 && _position < getDuration()) {
        return _position;
      }
      return Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  @override
  Duration getDuration() {
    // Return safe duration if no media is loaded or player is disposed
    try {
      if (medias.isEmpty || _player.state.playlist.medias.isEmpty) {
        return const Duration(seconds: 1);
      }
      return _duration.inSeconds > 0 ? _duration : const Duration(seconds: 1);
    } catch (e) {
      return const Duration(seconds: 1);
    }
  }

  @override
  void changeSpeed(double speed) {
    _player.setRate(speed);
  }

  @override
  Widget slider(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: StreamBuilder<Duration>(
        stream: _player.stream.position,
        builder: (context, snapshot) {
          // Use the internal _position that's already being tracked
          final position = _position;
          final duration =
              _duration.inSeconds > 0 ? _duration : const Duration(seconds: 1);

          // Only show slider if we have valid duration data
          if (_duration.inSeconds <= 0) {
            return const SizedBox.shrink();
          }

          return SliderTheme(
            data: const SliderThemeData(
              overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              thumbColor: Colors.red,
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
              value: position.inSeconds
                  .toDouble()
                  .clamp(0.0, duration.inSeconds.toDouble()),
              onChanged: (newValue) {
                final newPosition = Duration(seconds: newValue.toInt());
                _player.seek(newPosition);
              },
              min: 0,
              max: duration.inSeconds.toDouble(),
              divisions: duration.inSeconds > 0 ? duration.inSeconds : null,
            ),
          );
        },
      ),
    );
  }
}
