import 'dart:convert';

class ContentGenre {
  final int id;
  final String name;

  ContentGenre({required this.id, required this.name});

  factory ContentGenre.fromJson(String str) =>
      ContentGenre.fromMap(json.decode(str));

  factory ContentGenre.fromMap(Map<String, dynamic> json) => ContentGenre(
        id: json["id"],
        name: json["name"],
      );
}
