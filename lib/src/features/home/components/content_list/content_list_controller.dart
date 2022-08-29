import 'package:flutter/material.dart';
import 'package:netflix/src/features/home/components/content_list/content_container.dart';

class ContentListController extends ChangeNotifier {
  // consts
  double get spacing => 255;
  double get leftPadding => 30;
  static const Duration duration = Duration(milliseconds: 300);

  List<int> _currents = <int>[];
  List<int> get currents => _currents;

  Map<int, List<Widget>> _widgets = <int, List<Widget>>{};
  Map<int, List<Widget>> get widgets => _widgets;

  // Stores an old list of widgets in the list
  Map<int, List<Widget>> _oldWidgets = <int, List<Widget>>{};

  // Stores an "new" list of widgets in the list, the only difference is a widget added before widget 0
  Map<int, List<Widget>> _newWidgets = <int, List<Widget>>{};

  List<bool> _enabledLefts = <bool>[];
  List<bool> get enabledLefts => _enabledLefts;

  List<int> _contentLengths = <int>[];
  List<int> get contentLengths => _contentLengths;

  // A movie list is divided in 5 parts (when showing) this is an Index that shows the current part
  List<int> _selectedIndexes = <int>[];
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

  void addContent(int index) {}

  void init() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _widgets = [];
    // Widgets after
    for (int i = movies + 5; i >= movies; i--) {
      ContentContainerAnchor anchor = getAnchor(i);
      final container = ContentContainer(
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
      ContentContainerAnchor anchor = getAnchor(i);
      final container = ContentContainer(
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
      ContentContainerAnchor anchor = getAnchor(i);
      final container = ContentContainer(
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
    if (_enabledLeft) {
      return;
    }
    _enabledLeft = true;
    _oldWidgets = _newWidgets.toList();
    _widgets = _oldWidgets.toList();
    notifyListeners();
  }

  void changeOrder() {
    if (getAnchor(_current) == ContentContainerAnchor.center) {
      //
      print('changing order $_current');
      Future.delayed(duration).then((v) {
        // Error maybe because of new_widget
        int value = enabledLeft ? 6 : 0;
        Widget widget = _oldWidgets[widgets.length - _current - value];

        _widgets = _oldWidgets.toList();
        _widgets.removeAt(_widgets.length - _current - value);
        _widgets.insert(_widgets.length - _current - value, widget);

        notifyListeners();
      });
      //
    } else if (getAnchor(_current) == ContentContainerAnchor.right) {
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
