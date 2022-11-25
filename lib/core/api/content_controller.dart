import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';
import 'package:dio/dio.dart';

Future<Map<String, dynamic>> getHttp(String link) async {
  try {
    var response = await Dio().get(link);
    return response.data;
  } catch (e) {
    rethrow;
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

class ContentController extends ChangeNotifier {
  final Map<String, List<ContentModel>> _contentModel =
      <String, List<ContentModel>>{};

  bool loading = true;
  bool useOnline = true;
  int tvPage = 1;
  int moviePage = 1;
  final String apiKey = '69420';

  final List<String> _genres = [
    "Suspense No Ar",
    "Empolgante",
    "Excêntricos",
    "Realistas",
    "Esperto",
    "Adrenalina Pura",
    "Impacto visual",
    "Espirituosos",
  ];
  final Random _random = Random(69);
  final List<String> titles = ListContentsState.titles;

  void init() {
    if (!loading) {
      return;
    }
    rootBundle.loadString('assets/data/contents.json').then((value) {
      start(value);
    });
  }

  void start(String response) {
    final Map<String, dynamic> data = json.decode(response);

    List<String> keys = ['Herois e Outsiders', 'Em Alta'];
    if (data.isNotEmpty) {
      keys = data.keys.toList();

      for (int i = 0; i < keys.length; i++) {
        final Map<String, dynamic> contents = data[keys[i]];
        final List<String> contentsKeys = contents.keys.toList();
        final List<ContentModel> contentList = <ContentModel>[];
        //
        for (int j = 0; j <= contentsKeys.length - 1; j++) {
          if (contents[contentsKeys[j]]['age'] is String) {
            int? age = int.tryParse(contents[contentsKeys[j]]['age']);
            contents[contentsKeys[j]]['age'] = age ?? 0;
          }
          contentList.add(ContentModel.fromMap(contents[contentsKeys[j]]));
        }
        _contentModel[keys[i]] = contentList.toList();
      }
    }

    if (_contentModel.isNotEmpty) {
      loading = false;
      notifyListeners();
    }
  }

  String getKey(int index) {
    final keys = _contentModel.keys.toList();
    final int i = index > keys.length - 1 ? 0 : index;
    return keys[i];
  }

  List<String> getGenre(List<String> tvGenres) {
    List<String> genres = [];
    if (tvGenres.length < 3) {
      List<String> extras = [];
      List<String> aux = _genres.toList();
      for (int j = 0; j < 3 - tvGenres.length; j++) {
        int num = _random.nextInt(aux.length);
        extras.add(aux[num]);
        aux.removeAt(num);
      }
      genres = tvGenres + extras;
    } else if (_random.nextInt(3) > 1) {
      List<String> aux = tvGenres.sublist(0, 3);
      aux.insert(_random.nextInt(2), _genres[_random.nextInt(_genres.length)]);
      genres = aux.sublist(0, 3);
    } else {
      genres = tvGenres.sublist(0, 3);
    }

    return genres;
  }

  Future<void> getMixed(String id) async {
    List<ContentModel> contents = [];
    for (int l = 0; l < 2; l++) {
      List<ContentModel> results = await getSeries(tvPage);
      contents += results;
      tvPage++;
    }
    _contentModel[id] = contents.toList();
  }

  Future<List<ContentModel>> getSeries(int page) async {
    String logo = 'assets/data/logos/breaking_bad_logo.png';
    String trailer = 'https://www.youtube.com/watch?v=SPqNBE2xTUI';
    String backdrop = 'assets/data/backdrops/breaking_bad_backdrop.jpg';
    List<ContentModel> output = [];
    Map<String, dynamic> data = await getHttp(
        'https://api.themoviedb.org/4/discover/tv?api_key=$apiKey&language=pt-BR&page=$page&with_watch_providers=8&watch_region=BR');
    for (int k = 0; k < data.length; k++) {
      var i = data['results'][k];
      String tvId = i['id'].toString();
      Map<String, dynamic> tvData = await getHttp(
          'https://api.themoviedb.org/3/tv/$tvId?api_key=$apiKey&language=pt-BR&include_image_language=en,pt&append_to_response=release_dates,videos,images');
      int rating = (i['vote_average'] * 10).toInt();
      String title = i['name'];
      List<String> tvGenres = [];
      tvData['genres'].forEach((element) {
        tvGenres.add(element['name'].toString());
      });
      List<String> genres = getGenre(tvGenres);
      String details = tvData['number_of_seasons'].toString();
      String detail =
          details + ((details.length > 1) ? 'Temporadas' : 'Temporada');
      String overview = tvData['overview'].toString();

      Map<String, dynamic> ageData = await getHttp(
          'https://api.themoviedb.org/3/tv/$tvId/content_ratings?api_key=$apiKey&language=pt-BR');
      int age = 0;
      for (var a in ageData['results']) {
        String ageRating = a['rating'].toString();
        if (!isNumeric(ageRating)) {
          continue;
        }
        String country = a['iso_3166_1'].toString();
        age = int.tryParse(ageRating) ?? 0;
        if (country == 'BR') {
          break;
        }
      }
      Map<String, dynamic> onlyData = await getHttp(
          'https://api.themoviedb.org/3/tv/$tvId/watch/providers?api_key=$apiKey&language=pt-BR');
      // Determines if the content is only on netflix

      bool onlyOnNetflix = false;
      if (onlyData['BR'] != null) {
        onlyOnNetflix = onlyData['BR']['flatrate'].length == 1;
      } else if (onlyData['US'] != null) {
        onlyOnNetflix = onlyData['US']['flatrate'].length == 1;
      }
      String poster = 'https://image.tmdb.org/t/p/w400${i["backdrop_path"]}';
      if (i['background_path'].toString().isEmpty) {
        poster =
            'https://image.tmdb.org/t/p/w400/yXSzo0VU1Q1QaB7Xg5Hqe4tXXA3.jpg';
      } else {
        var postersData = tvData['images'];
        for (var b in postersData['backdrops']) {
          poster = 'https://image.tmdb.org/t/p/w400${b["file_path"]}';
          if (b['iso_639_1'] == 'pt') {
            break;
          }
        }
      }
      ContentModel content = ContentModel(
          logo: logo,
          isOnline: true,
          age: age,
          detail: detail,
          tags: genres,
          rating: rating,
          trailer: trailer,
          poster: poster,
          backdrop: backdrop,
          title: title,
          overview: overview);
      output.add(content);
    }
    return output;
  }

  void getFilms() {}

  ContentModel concate(String id, int index) {
    if (index < 0) {
      index = 0;
    }
    final keys = _contentModel.keys.toList();
    final String i = _contentModel[id] == null ? keys[0] : id;
    int ind = index > _contentModel[i]!.length - 1
        ? _contentModel[i]!.length - 1
        : index;
    if (ind < 0) {
      ind = 0;
    }
    // print('PRINT: $ind, $index, $i ,${_contentModel[i]!.length}');
    return _contentModel[i]![ind];
  }

  Future<ContentModel> getContent(String id, int index) async {
    if (useOnline && _contentModel[id] == null) {
      switch (titles.indexOf(id) % 3) {
        default:
          var value = await getMixed(id);
          return concate(id, index);
        // case 1:
        //   getFilms();
        //   break;
        // case 2:
        //   getSeries();
        //   break;
      }
    } else {
      return concate(id, index);
    }
  }
}
