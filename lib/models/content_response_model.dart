import 'dart:convert';

import 'content_model.dart';

class ContentResponseModel {
  int page;
  final int totalResults;
  final int totalPages;
  final List<ContentModel> movies;

  ContentResponseModel({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.movies,
  });

  factory ContentResponseModel.fromJson(String str) =>
      ContentResponseModel.fromMap(json.decode(str));

  factory ContentResponseModel.fromMap(Map<String, dynamic> json) =>
      ContentResponseModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<ContentModel>.from(
            json["results"].map((x) => ContentModel.fromMap(x))),
      );
}
