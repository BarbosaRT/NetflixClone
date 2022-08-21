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
  //bool _isLeft = false;
  //bool get isLeft => _isLeft;

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
    for (int i = 25; i >= 0; i--) {
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

  void changeCurrent(int index) {
    _current = index;
    notifyListeners();
  }
}
