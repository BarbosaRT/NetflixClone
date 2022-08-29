import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:netflix/core/api/http_interface.dart';

import '../core/api/api.dart';
import '../errors/content_error.dart';
import '../models/content_detail_model.dart';
import '../models/content_response_model.dart';

class ContentRepository {
  final Dio dio = Dio(kDioOptions);
  late final HttpInterface httpInterface;

  ContentRepository() {
    httpInterface = DioImpl(dio: dio);
  }

  Future<Either<ContentError, ContentResponseModel>> fetchAllMovies(
      int page) async {
    try {
      final response = await httpInterface.get('/movie/popular?page=$page');
      final model = ContentResponseModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response!.data['status_message']));
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<ContentError, MovieDetailModel>> fetchMovieById(int id) async {
    try {
      final response = await httpInterface.get('/movie/$id');
      final model = MovieDetailModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response!.data['status_message']));
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
