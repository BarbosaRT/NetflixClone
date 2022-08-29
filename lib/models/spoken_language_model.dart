import 'dart:convert';

class SpokenLanguageModel {
  final String iso6391;
  final String name;

  SpokenLanguageModel({
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguageModel.fromJson(String str) =>
      SpokenLanguageModel.fromMap(json.decode(str));

  factory SpokenLanguageModel.fromMap(Map<String, dynamic> json) =>
      SpokenLanguageModel(
        iso6391: json['iso_639_1'],
        name: json['name'],
      );
}
