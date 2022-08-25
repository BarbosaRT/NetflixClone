import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/movie_list/movie_container.dart';

class MovieListController extends ChangeNotifier {
  int _current = 0;

  int get current => _current;

  double get spacing => 270;

  List<Widget> _widgets = [];
  List<Widget> get widgets => _widgets;

  List<Widget> test = [];

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
    for (int i = 4; i >= 0; i--) {
      MovieContainerAnchor anchor = getAnchor(i);
      final container = MovieContainer(
        index: i,
        anchor: anchor,
      );
      _widgets.add(Positioned(
        left: spacing * i,
        child: container,
      ));
    }

    test = _widgets.toList();

    notifyListeners();
  }

  void changeOrder() {
    if (getAnchor(_current) == MovieContainerAnchor.center) {
      //
      Future.delayed(duration).then((v) {
        Widget widget = test[widgets.length - _current];
        int index = _widgets.indexOf(widget);

        _widgets = test.toList();
        _widgets.removeAt(index);
        _widgets.insert(_widgets.length - _current, widget);

        notifyListeners();
      });
      //
    } else if (getAnchor(_current) == MovieContainerAnchor.right) {
      Future.delayed(duration).then((v) {
        _widgets = test.reversed.toList();
        notifyListeners();
      });
    } else {
      Future.delayed(duration).then((v) {
        _widgets = test.toList();
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
