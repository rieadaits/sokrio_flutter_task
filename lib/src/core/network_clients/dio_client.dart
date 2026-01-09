import 'package:dio/dio.dart';
import 'package:sokrio_flutter_task/src/core/constant/api_urls.dart';
import 'package:sokrio_flutter_task/src/core/network_clients/connectivity_interceptor.dart';
import 'package:sokrio_flutter_task/src/core/network/network_info.dart';
import 'package:sokrio_flutter_task/src/core/network_clients/retry_interceptor.dart';


class DioClient {
  late final Dio _dio;
  late final NetworkInfo networkInfo;

  DioClient({required this.networkInfo}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseURL,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          ///Please replace [ApiUrls.apiKey] with your API key
          ///My api key has been hidden in .env file for security reasons
          ///My .env file is included in .gitignore
          ///This is how I keep my api key secure
          "x-api-key": ApiUrls.apiKey, 
        },
      ),
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(networkInfo: networkInfo),
      RetryInterceptor(dio: _dio),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  // Expose the Dio instance for Retrofit
  Dio get dio => _dio;
}
