enum Status { succes, loading, error, timeout, internetError }

class NetworkResponse {
  final Status status;
  final Map<String, dynamic>? data;
  final String? message;
  NetworkResponse(this.status, this.data, this.message);

  static NetworkResponse succes(data) {
    return NetworkResponse(Status.succes, data, null);
  }

  static NetworkResponse error({data, String? message}) {
    return NetworkResponse(Status.error, data, message);
  }

  static NetworkResponse internetError() {
    return NetworkResponse(Status.internetError, null, null);
  }
}
