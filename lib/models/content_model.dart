import 'dart:convert';

class ContentModel {
  final int rating;
  final String trailer;
  final String poster;
  final String backdrop;
  final List<dynamic> tags;
  final int age;
  final String detail;
  final String logo;
  final String title;
  final bool isOnline;
  final bool onlyOnNetflix;
  String overview;
  bool hasDetailPage;
  List<dynamic>? cast;
  Map<dynamic, dynamic>? episodes;

  ContentModel({
    this.hasDetailPage = false,
    this.cast,
    this.episodes,
    required this.onlyOnNetflix,
    required this.logo,
    required this.isOnline,
    required this.age,
    required this.detail,
    required this.tags,
    required this.rating,
    required this.trailer,
    required this.poster,
    required this.backdrop,
    required this.title,
    required this.overview,
  });

  factory ContentModel.fromJson(String str) =>
      ContentModel.fromMap(json.decode(str));

  factory ContentModel.fromMap(Map<String, dynamic> json) => ContentModel(
      rating: json["rating"] ?? 98,
      trailer:
          json["trailer"] ?? "assets/data/trailers/breaking_bad_trailer.mp4",
      logo: json['logo'] ?? "assets/data/logos/breaking_bad_logo.png",
      detail: json['detail'] ?? "5 temporadas",
      poster: json["poster"] ?? "assets/data/posters/breaking_bad_poster.jpg",
      backdrop:
          json["backdrop"] ?? "assets/data/backdrops/breaking_bad_backdrop.jpg",
      title: json["title"] ?? "Breaking Bad",
      overview: json["overview"] ?? "",
      hasDetailPage: json["hasDetailPage"] ?? false,
      cast: json["cast"],
      episodes: json["episodes"],
      age: json['age'] ?? 0,
      tags: json['tags'] ?? ["Violentos", "Realistas", "Suspense"],
      isOnline: json["isOnline"] ?? false,
      onlyOnNetflix: json['onlyOnNetflix'] ?? false);
}
