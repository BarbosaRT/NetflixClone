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
  final String overview;

  const ContentModel({
    required this.logo,
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
      rating: json["rating"],
      trailer: json["trailer"],
      logo: json['logo'],
      detail: json['detail'],
      poster: json["poster"],
      backdrop: json["backdrop"],
      title: json["title"],
      overview: json["overview"],
      age: json['age'],
      tags: json['tags']);
}
