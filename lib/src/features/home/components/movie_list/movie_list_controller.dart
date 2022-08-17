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
  bool _canChange = false;
  bool get canChange => _canChange;

  MovieContainerAnchor getAnchor(int i) {
    MovieContainerAnchor anchor = MovieContainerAnchor.center;
    if (i % 4 == 0) {
      anchor = MovieContainerAnchor.right;
    }
    if (i % 5 == 0) {
      anchor = MovieContainerAnchor.left;
    }
    return anchor;
  }

  void init() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _widgets = [];
    for (int i = 45; i >= 0; i--) {
      MovieContainerAnchor anchor = getAnchor(i);
      _widgets.add(Positioned(
        left: spacing * i,
        child: MovieContainer(
          index: i,
          anchor: anchor,
          elevation: i == 1 ? 10 : 0,
        ),
      ));
      test = _widgets.toList();
    }

    notifyListeners();
  }

  void disableChange() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      _canChange = true;
      notifyListeners();
    });
  }

  void changeCurrent(int index) {
    if (!_canChange) {
      return;
    }
    print('test: $index');
    _current = index;
    notifyListeners();
  }
}

class CurrentMovie extends ValueNotifier<int> {
  CurrentMovie(super.value);
  void changeCurrent(int index) {
    Future.delayed(const Duration(milliseconds: 50)).then((v) {
      value = index;
      notifyListeners();
    });
  }
}
