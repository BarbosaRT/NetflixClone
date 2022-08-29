import 'dart:convert';

class ProductionCountryModel {
  final String iso31661;
  final String name;

  ProductionCountryModel({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountryModel.fromJson(String str) =>
      ProductionCountryModel.fromMap(json.decode(str));

  factory ProductionCountryModel.fromMap(Map<String, dynamic> json) =>
      ProductionCountryModel(
        iso31661: json['iso_3166_1'],
        name: json['name'],
      );
}
