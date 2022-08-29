import 'package:flutter/material.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/src/features/home/components/content_list/content_container.dart';

class ContentListController extends ChangeNotifier {
  // consts
  double get spacing => 255;
  double get leftPadding => 30;
  static const Duration duration = Duration(milliseconds: 300);

  final _controller = ContentController();

  final List<int> _currents = <int>[0];
  List<int> get currents => _currents;

  final Map<int, List<Widget>> _widgets = <int, List<Widget>>{0: []};
  Map<int, List<Widget>> get widgets => _widgets;

  // Stores an old list of widgets in the list
  final Map<int, List<Widget>> _oldWidgets = <int, List<Widget>>{0: []};

  // Stores an "new" list of widgets in the list, the only difference is a widget added before widget 0
  final Map<int, List<Widget>> _newWidgets = <int, List<Widget>>{0: []};

  final List<bool> _enabledLefts = <bool>[false];
  List<bool> get enabledLefts => _enabledLefts;

  final List<int> _contentLengths = <int>[0];
  List<int> get contentLengths => _contentLengths;

  // A movie list is divided in 5 parts (when showing) this is an Index that shows the current part
  final List<int> _selectedIndexes = <int>[1];
  List<int> get selectedIndexes => _selectedIndexes;

  void changeIndex(int newIndex, int index) {
    if (_selectedIndexes.length - 1 < index) {
      return;
    }
    _selectedIndexes[index] = newIndex;
    notifyListeners();
  }

  ContentContainerAnchor getAnchor(int i) {
    int v = i >= 5 ? i - 5 * (i ~/ 5) : i;

    List<ContentContainerAnchor> anchors = [
      ContentContainerAnchor.left,
      ContentContainerAnchor.center,
      ContentContainerAnchor.center,
      ContentContainerAnchor.center,
      ContentContainerAnchor.right,
    ];
    return anchors[v];
  }

  bool _initialized = false;

  void init(int index) async {
    if (_initialized) {
      return;
    }
    await _controller.fetchAllMovies();

    //print(_controller.contents);
    //print(_controller.loading);
    //print(_controller.contentError);

    if (!_controller.loading && _controller.contentError == null) {
      //
      _initialized = true;
      //print(_controller.contents[10].backdropPath);
      _contentLengths[index] = _controller.contents.length - 10;
      // Widgets after
      for (int i = _contentLengths[index] + 5;
          i >= _contentLengths[index];
          i--) {
        ContentContainerAnchor anchor = getAnchor(i);
        final content = _controller.contents[i];
        //
        final container = ContentContainer(
          index: (i - _contentLengths[index]),
          anchor: anchor,
          posterPath: content.backdropPath,
        );
        //
        _widgets[index]!.add(Positioned(
          left: spacing * (i + 5) + leftPadding,
          child: container,
        ));
      }
      // The Movies itself
      for (int i = _contentLengths[index] - 1; i >= 0; i--) {
        ContentContainerAnchor anchor = getAnchor(i);
        final content = _controller.contents[i];
        final container = ContentContainer(
          index: i,
          anchor: anchor,
          posterPath: content.backdropPath,
        );
        _widgets[index]!.add(Positioned(
          left: spacing * (i + 5) + leftPadding,
          child: container,
        ));
      }

      _oldWidgets[index] = _widgets[index]!.toList();

      _newWidgets[index] = _widgets[index]!.toList();

      // Movies before
      for (int i = _contentLengths[index] - 1;
          i >= _contentLengths[index] - 5;
          i--) {
        ContentContainerAnchor anchor = getAnchor(i);
        final content = _controller.contents[i];
        final container = ContentContainer(
          index: i,
          anchor: anchor,
          posterPath: content.backdropPath,
        );
        _newWidgets[index]!.add(Positioned(
          left: spacing * (i - 20) + leftPadding,
          child: container,
        ));
      }

      notifyListeners();
    }
  }

  void enableLeft(int index) {
    if (_enabledLefts[index]) {
      return;
    }
    _enabledLefts[index] = true;
    _oldWidgets[index] = _newWidgets[index]!.toList();
    _widgets[index] = _oldWidgets[index]!.toList();
    notifyListeners();
  }

  void changeOrder(int index) {
    if (getAnchor(_currents[index]) == ContentContainerAnchor.center) {
      //
      Future.delayed(duration).then((v) {
        // Error maybe because of new_widget
        int value = enabledLefts[index] ? 6 : 0;
        Widget widget = _oldWidgets[index]![
            widgets[index]!.length - _currents[index] - value];

        _widgets[index] = _oldWidgets[index]!.toList();
        _widgets[index]!
            .removeAt(_widgets[index]!.length - _currents[index] - value);
        _widgets[index]!
            .insert(_widgets[index]!.length - _currents[index] - value, widget);

        notifyListeners();
      });
      //
    } else if (getAnchor(_currents[index]) == ContentContainerAnchor.right) {
      Future.delayed(duration).then((v) {
        _widgets[index] = _oldWidgets[index]!.reversed.toList();
        notifyListeners();
      });
    } else {
      Future.delayed(duration).then((v) {
        _widgets[index] = _oldWidgets[index]!.toList();
        notifyListeners();
      });
    }
  }

  void changeCurrent(int newIndex, int index) {
    if (newIndex == _currents[index]) {
      return;
    }
    _currents[index] = newIndex;
    changeOrder(index);
  }
}
