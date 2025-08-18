import '../../network/api-responses.dart';

abstract class IRepository {
  Future<ApiResponse> logOut();

  Future<ApiResponse> refresh(Map<String, dynamic> req);
}