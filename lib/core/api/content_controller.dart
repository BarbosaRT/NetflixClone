import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/list_contents.dart';
import 'package:http/http.dart' as http;

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
  http.Client client = http.Client();

  final String apiKey = '456a2c767a26c3bd89a076ab4ec8f89b';

  List<String> verifiedTitles = [];

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

  Future<dynamic> getHttp(String link) async {
    try {
      var response = jsonDecode((await client.get(Uri.parse(link))).body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> init() async {
    if (!loading) {
      return;
    }
    var value = await rootBundle.loadString('assets/data/contents.json');
    start(value);
  }

  void start(String response) {
    final Map<String, dynamic> data = json.decode(response);

    List<String> keys = ['Outsiders', 'Em Alta'];
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
          ContentModel content =
              ContentModel.fromMap(contents[contentsKeys[j]]);
          print(content.title);
          contentList.add(content);
        }
        _contentModel[keys[i]] = contentList.toList();
      }
    }
    loading = false;
    notifyListeners();
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
    Map<String, String> translations = {
      'Action & Adventure': 'Ação e Aventura',
      'Sci-Fi & Fantasy': 'Sci-Fi e Fantasia'
    };
    for (String genre in genres) {
      if (translations.containsKey(genre)) {
        genres.removeAt(genres.indexOf(genre));
        genres.add(translations[genre]!);
      }
    }

    return genres;
  }

  String getPoster(Map<String, dynamic> i, Map<String, dynamic> data) {
    String poster = 'https://image.tmdb.org/t/p/w400${i["backdrop_path"]}';
    if (i['background_path'].toString().isEmpty) {
      poster =
          'https://image.tmdb.org/t/p/w400/yXSzo0VU1Q1QaB7Xg5Hqe4tXXA3.jpg';
    } else {
      var postersData = data['images'];
      for (var b in postersData['backdrops']) {
        poster = 'https://image.tmdb.org/t/p/w400${b["file_path"]}';
        if (b['iso_639_1'] == 'pt') {
          break;
        }
      }
    }
    return poster;
  }

  Future<void> getMixed(String id) async {
    if (_contentModel.containsKey(id)) {
      return;
    }
    List<ContentModel> contents = [];

    List<ContentModel> films = await getFilms();
    contents += films.toList();

    List<ContentModel> series = await getSeries();
    contents += series.toList();

    //print('PRINT (getMixed): ${contents.length}, $tvPage, $id');
    _contentModel[id] = contents.toList();
    notifyListeners();
  }

  Future<List<ContentModel>> getSeries() async {
    tvPage += 1;
    int page = tvPage;
    String logo = 'assets/data/logos/breaking_bad_logo.png';
    String trailer = '';
    String backdrop = 'assets/data/backdrops/breaking_bad_backdrop.jpg';
    List<ContentModel> output = [];
    Map<String, dynamic> data = await getHttp(
        'https://api.themoviedb.org/4/discover/tv?api_key=$apiKey&language=pt-BR&page=$page&with_watch_providers=8&watch_region=BR');
    for (int k = 0; k < data['results'].length; k++) {
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
          details + ((details.length > 1) ? ' Temporadas' : ' Temporada');
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
      List<dynamic> trailerData = tvData['videos']['results'];
      if (trailerData.isNotEmpty) {
        if (trailerData[0]['site'] == 'YouTube') {
          trailer = 'https://yewtu.be/watch?v=${trailerData[0]["key"]}';
        } else {
          trailer = await getTrailer(title);
        }
      } else {
        trailer = await getTrailer(title);
      }

      String poster = getPoster(i, tvData);
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
      //print('CONTENT: $title $page');
      output.add(content);
    }
    return output.toList();
  }

  Future<List<ContentModel>> getFilms() async {
    moviePage += 1;
    int page = moviePage;
    String logo = 'assets/data/logos/breaking_bad_logo.png';
    String trailer = '';
    String backdrop = 'assets/data/backdrops/breaking_bad_backdrop.jpg';
    List<ContentModel> output = [];
    Map<String, dynamic> data = await getHttp(
        'https://api.themoviedb.org/4/discover/movie?api_key=$apiKey&language=pt-BR&page=$page&with_watch_providers=8&watch_region=BR&sort_by=vote_count.desc');
    for (int k = 0; k < data['results'].length; k++) {
      var i = data['results'][k];
      String movieId = i['id'].toString();
      Map<String, dynamic> movieData = await getHttp(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=pt-BR&include_image_language=en,pt&append_to_response=release_dates,videos,images');
      int rating = (i['vote_average'] * 10).toInt();
      String title = i['title'];
      List<String> movieGenres = [];
      movieData['genres'].forEach((element) {
        movieGenres.add(element['name'].toString());
      });
      List<String> genres = getGenre(movieGenres);
      int runtime = int.parse(movieData['runtime'].toString());
      String detail = '${runtime}min';
      if (runtime >= 60) {
        detail = '${runtime ~/ 60}h ${runtime - (runtime ~/ 60) * 60}min';
      }
      String overview = movieData['overview'].toString();

      Map<String, dynamic> ageData = movieData['release_dates'];
      int age = 0;
      for (var a in ageData['results']) {
        if (a['iso_3166_1'].toString() == 'BR') {
          String aux = a['release_dates'][0]['certification'].toString();
          if (aux != 'L' && !isNumeric(aux)) {
            aux = 'L';
          }
          age = aux != 'L' ? int.parse(aux) : 0;
          break;
        }
      }
      String poster = getPoster(i, movieData);

      List<dynamic> trailerData = movieData['videos']['results'];
      if (trailerData.isNotEmpty) {
        if (trailerData[0]['site'] == 'YouTube') {
          trailer = 'https://yewtu.be/watch?v=${trailerData[0]["key"]}';
        } else {
          trailer = 'https://yewtu.be/watch?v=${await getTrailer(title)}';
        }
      } else {
        trailer = 'https://yewtu.be/watch?v=${await getTrailer(title)}';
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
      //print('CONTENT: $title $page');
      output.add(content);
    }
    return output.toList();
  }

  String urlEncode(String text) {
    String output = text.toString();
    output = output.replaceAll('#', '%23');
    output = output.replaceAll('&', '%26');
    output = output.replaceAll('/', '%2F');
    output = output.replaceAll(' ', '+');
    return output;
  }

  Future<String> getTrailer(String title) async {
    List<dynamic> results = await getHttp(
        'https://inv.riverside.rocks/api/v1/search?q=${urlEncode(title)}+trailer');

    String trailer = 'vDY_uZAaU7g';
    trailer = results[0]['videoId'];
    return trailer;
  }

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
    //Unhandled Exception: RangeError (index): Invalid value: Valid value range is empty: 0
    return _contentModel[i]![ind];
  }

  Future<ContentModel> getContent(String id, int index) async {
    if (_contentModel[id] == null && !verifiedTitles.contains(id)) {
      var response = await rootBundle.loadString('assets/data/contents.json');
      Map<String, dynamic> data = jsonDecode(response);
      if (data.keys.toList().contains(id)) {
        if (!loading) {
          await init();
        }
        verifiedTitles.add(id);
        return concate(id, index);
      } else {
        verifiedTitles.add(id);
      }
    }
    if (useOnline && _contentModel[id] == null) {
      switch (titles.indexOf(id) % 3) {
        case 0:
          await getMixed(id);
          return concate(id, index);
        case 1:
          List<ContentModel> contents = [];
          for (int k = 0; k <= 2; k++) {
            List<ContentModel> films = await getFilms();
            contents += films.toList();
          }
          _contentModel[id] = contents.toList();
          return concate(id, index);
        case 2:
          List<ContentModel> contents = [];
          for (int k = 0; k <= 2; k++) {
            List<ContentModel> series = await getSeries();
            contents += series.toList();
          }
          _contentModel[id] = contents.toList();
          return concate(id, index);
        default:
          await getMixed(id);
          return concate(id, index);
      }
    } else {
      return concate(id, index);
    }
  }
}
