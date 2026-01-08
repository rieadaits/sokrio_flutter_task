import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retries = err.requestOptions.extra['retries'] ?? 0;

    if (_shouldRetry(err) && retries < maxRetries) {
      err.requestOptions.extra['retries'] = retries + 1;
      await Future.delayed(Duration(seconds: retries + 1));

      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError;
  }
}
