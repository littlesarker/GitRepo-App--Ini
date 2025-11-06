class ApiResponse {
  Object? data;
  bool isSuccessful;
  int statusCode;
  String? status;
  String? message;
  ApiResponse({
    this.data,
    required this.isSuccessful,
    this.statusCode = 420,
    this.status,
    this.message,
  });

  @override
  String toString() {
    return 'ApiResponse(data: $data, isSuccessful: $isSuccessful, statusCode: $statusCode, status: $status, message: $message)';
  }
}
