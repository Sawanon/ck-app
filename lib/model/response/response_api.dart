class ResponseApi<T> {
  bool isSuccess;
  String message;
  T? data;

  ResponseApi({
    required this.isSuccess,
    required this.message,
    this.data,
  });
}
