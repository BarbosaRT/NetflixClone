import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:netflix/models/content_model.dart';

class ContentController extends ChangeNotifier {
  final Map<String, List<ContentModel>> _contentModel =
      <String, List<ContentModel>>{};

  bool loading = true;

  void init() async {
    final String response = await rootBundle.loadString('data/contents.json');
    final Map<String, dynamic> data = await json.decode(response);

    List<String> keys = ['Herois e Outsiders', 'Em Alta'];
    if (data.isNotEmpty) {
      keys = data.keys.toList();
    }

    for (int i = 0; i < keys.length; i++) {
      final List<dynamic> contents = data[keys[i]];
      final List<ContentModel> contentList = [];
      //
      for (int i = 0; i <= contents.length - 1; i++) {
        contentList.add(ContentModel.fromMap(contents[i]));
      }
      _contentModel[keys[i]] = contentList.toList();
    }

    if (_contentModel.isNotEmpty) {
      loading = false;
      notifyListeners();
    }
  }

  String getKey(int index) {
    final keys = _contentModel.keys.toList();
    final int i = index >= keys.length - 1 ? 0 : index;
    return keys[i];
  }

  ContentModel getContent(String id, int index) {
    final keys = _contentModel.keys.toList();
    final String i = _contentModel[id] == null ? keys[0] : id;
    final int ind = index >= keys.length - 1 ? 0 : index;
    return _contentModel[i]![ind];
  }
}
