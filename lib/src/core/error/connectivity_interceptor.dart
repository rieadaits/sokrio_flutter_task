import 'package:dio/dio.dart';
import 'package:sokrio_flutter_task/src/core/error/network_info.dart';

class ConnectivityInterceptor extends Interceptor {
  late final NetworkInfo networkInfo;

  ConnectivityInterceptor({required this.networkInfo});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: "No Internet Connection",
        ),
      );
    }
    handler.next(options);
  }
}
