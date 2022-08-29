abstract class ContentError implements Exception {
  String message = '';

  @override
  String toString() {
    return message;
  }
}

class MovieRepositoryError extends ContentError {
  MovieRepositoryError(String message) {
    this.message = message;
  }
}
