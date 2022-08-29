import 'package:flutter_test/flutter_test.dart';
import 'package:netflix/errors/content_error.dart';
import 'package:netflix/models/content_response_model.dart';
import 'package:netflix/repositories/content_repository.dart';

import 'package:dartz/dartz.dart';

void main() {
  final repository = ContentRepository();

  test('Should get all popular movies', () async {
    final result = await repository.fetchAllMovies(1);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<ContentResponseModel>());
  });

  test('Should error to get all popular movies', () async {
    final result = await repository.fetchAllMovies(1000);
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<ContentError>());
  });
}
