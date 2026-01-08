import 'package:dio/dio.dart';
import 'package:sokrio_flutter_task/src/core/constant/api_urls.dart';
import 'package:sokrio_flutter_task/src/core/error/connectivity_interceptor.dart';
import 'package:sokrio_flutter_task/src/core/error/network_info.dart';
import 'package:sokrio_flutter_task/src/core/network/retry_interceptor.dart';

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
