import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_container.dart';

class MovieListController extends ChangeNotifier {
  int _current = 0;

  int get current => _current;

  double get spacing => 252;
  double get leftPadding => 50;

  List<Widget> _widgets = [];
  List<Widget> get widgets => _widgets;

  // Stores an old list of widgets in the list
  List<Widget> _oldWidgets = [];
  // Stores an "new" list of widgets in the list, the only difference is a widget added before widget 0
  List<Widget> _newWidgets = [];

  bool _enabledLeft = false;
  bool get enabledLeft => _enabledLeft;

  int movies = 25;

  bool _initialized = false;
  static const Duration duration = Duration(milliseconds: 300);

  MovieContainerAnchor getAnchor(int i) {
    int v = i >= 5 ? i - 5 * (i ~/ 5) : i;

    List<MovieContainerAnchor> anchors = [
      MovieContainerAnchor.left,
      MovieContainerAnchor.center,
      MovieContainerAnchor.center,
      MovieContainerAnchor.center,
      MovieContainerAnchor.right,
    ];
    return anchors[v];
  }

  void init() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _widgets = [];
    // Widgets after
    for (int i = movies + 5; i >= movies; i--) {
      MovieContainerAnchor anchor = getAnchor(i);
      final container = MovieContainer(
        index: (i - movies),
        anchor: anchor,
      );
      _widgets.add(Positioned(
        left: spacing * (i + 5) + leftPadding,
        child: container,
      ));
    }
    // The Movies itself
    for (int i = movies - 1; i >= 0; i--) {
      MovieContainerAnchor anchor = getAnchor(i);
      final container = MovieContainer(
        index: i,
        anchor: anchor,
      );
      _widgets.add(Positioned(
        left: spacing * (i + 5) + leftPadding,
        child: container,
      ));
    }

    _oldWidgets = _widgets.toList();

    _newWidgets = _widgets.toList();
    // Movies before
    for (int i = 24; i >= 19; i--) {
      MovieContainerAnchor anchor = getAnchor(i);
      final container = MovieContainer(
        index: i,
        anchor: anchor,
      );
      _newWidgets.add(Positioned(
        left: spacing * (i - 20) + leftPadding,
        child: container,
      ));
    }

    notifyListeners();
  }

  void enableLeft() {
    _enabledLeft = true;
    _oldWidgets = _newWidgets.toList();
    _widgets = _oldWidgets.toList();
    notifyListeners();
  }

  void changeOrder() {
    if (getAnchor(_current) == MovieContainerAnchor.center) {
      //
      print('changing order $_current');
      Future.delayed(duration).then((v) {
        Widget widget = _oldWidgets[widgets.length - _current];

        _widgets = _oldWidgets.toList();
        _widgets.removeAt(_widgets.length - _current);
        _widgets.insert(_widgets.length - _current, widget);

        notifyListeners();
      });
      //
    } else if (getAnchor(_current) == MovieContainerAnchor.right) {
      Future.delayed(duration).then((v) {
        _widgets = _oldWidgets.reversed.toList();
        notifyListeners();
      });
    } else {
      Future.delayed(duration).then((v) {
        _widgets = _oldWidgets.toList();
        notifyListeners();
      });
    }
  }

  void changeCurrent(int index) {
    if (index == _current) {
      return;
    }
    _current = index;
    changeOrder();
  }
}
