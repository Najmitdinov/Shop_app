class HttpException implements Exception {
  final String messanger;

  HttpException(this.messanger);

  @override
  String toString() {
    return messanger;
  }
}
