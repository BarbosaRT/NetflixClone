import 'dart:convert';

class ProductionCompanyModel {
  final int id;
  final String name;
  final String logoPath;
  final String originCountry;

  ProductionCompanyModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompanyModel.fromJson(String str) =>
      ProductionCompanyModel.fromMap(json.decode(str));

  factory ProductionCompanyModel.fromMap(Map<String, dynamic> json) =>
      ProductionCompanyModel(
        id: json['id'],
        name: json['name'],
        logoPath: json['logoPath'],
        originCountry: json['originCountry'],
      );
}
