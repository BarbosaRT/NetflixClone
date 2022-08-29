import 'package:dartz/dartz.dart';
import 'package:netflix/errors/content_error.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/models/content_response_model.dart';
import 'package:netflix/repositories/content_repository.dart';

class ContentController {
  final _repository = ContentRepository();

  ContentResponseModel? contentResponseModel;
  ContentError? contentError;
  bool loading = true;

  List<ContentModel> contents = [];
  int get contentCount => contents.length;
  bool get hasContent => contentCount != 0;
  int get totalPages => contentResponseModel?.totalPages ?? 1;
  int get currentPage => contentResponseModel?.page ?? 1;

  Future<Either<ContentError, ContentResponseModel>> fetchAllMovies(
      {int page = 1}) async {
    contentError = null;

    final result = await _repository.fetchAllMovies(page);
    result.fold(
      (error) => contentError = error,
      (movie) {
        if (contentResponseModel == null) {
          contentResponseModel = movie;
        } else {
          contentResponseModel!.page = movie.page;
          contentResponseModel!.movies.addAll(movie.movies);
        }
        contents = contentResponseModel!.movies;
      },
    );
    loading = false;
    return result;
  }
}
