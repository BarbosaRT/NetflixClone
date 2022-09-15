import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:netflix/models/content_model.dart';

class ContentController extends ChangeNotifier {
  final List<ContentModel> _contentModel = <ContentModel>[];

  bool loading = true;

  void init() async {
    final String response = await rootBundle.loadString('data/contents.json');
    final data = await json.decode(response);

    final List<dynamic> contents = data["0"];
    for (int i = 0; i <= contents.length - 1; i++) {
      _contentModel.add(ContentModel.fromMap(contents[i]));
    }
    if (_contentModel.isNotEmpty) {
      loading = false;
      notifyListeners();
    }
  }

  ContentModel getContent(int index) {
    final i = index > _contentModel.length - 1 ? 0 : index;
    return _contentModel[i];
  }
}
