import 'package:_247remotejobs/core/data/repositories/repository-interface.dart';

import '../../../app/app.locator.dart';
import '../../network/api-responses.dart';
import '../../network/api-service.dart';

class Repository extends IRepository {
  final api = locator<ApiService>();

  @override
  Future<ApiResponse> logOut() async {
    ApiResponse response = await api.call(
        method: HttpMethod.post,
        endpoint: "auth/logout"
    );

    return response;
  }

  @override
  Future<ApiResponse> refresh(Map<String, dynamic> req) async {
    ApiResponse response = await api.call(
        method: HttpMethod.postRefresh,
        endpoint: "auth/refresh_tokens",
        reqBody: req
    );
    return response;
  }
}