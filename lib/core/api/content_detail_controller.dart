import 'package:dartz/dartz.dart';
import 'package:netflix/errors/content_error.dart';
import 'package:netflix/models/content_detail_model.dart';
import 'package:netflix/repositories/content_repository.dart';

class ContentDetailController {
  final _repository = ContentRepository();

  ContentDetailModel? contentDetail;
  ContentError? contentError;

  bool loading = true;

  Future<Either<ContentError, ContentDetailModel>> fetchContentById(
      int id) async {
    contentError = null;
    final result = await _repository.fetchContentById(id);
    result.fold(
      (error) => contentError = error,
      (detail) => contentDetail = detail,
    );
    return result;
  }
}
