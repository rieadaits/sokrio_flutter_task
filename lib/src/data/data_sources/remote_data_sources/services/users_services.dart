import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sokrio_flutter_task/src/core/constant/api_urls.dart';
import 'package:sokrio_flutter_task/src/data/models/users_response.dart';

part 'users_services.g.dart';

@RestApi(baseUrl: "/api")
abstract class UsersService {
  factory UsersService(Dio dio) = _UsersService;

  @GET(ApiUrls.getUser)
  Future<UsersResponse> getUsers({
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });
}
