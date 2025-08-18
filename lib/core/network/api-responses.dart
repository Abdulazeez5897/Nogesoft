import 'package:dio/dio.dart';


/// @author Usman Abdulazeez
/// email: abdulazeezusman732@gmail.com
/// Aug, 2025
///

class ApiResponse {
  Response response;

  ApiResponse(this.response);

  dynamic _data;
  int? _statusCode;

  dynamic get data {
    _data = response.data;
    return _data;
  }

  int? get statusCode {
    _statusCode = response.statusCode;
    return _statusCode;
  }
}
