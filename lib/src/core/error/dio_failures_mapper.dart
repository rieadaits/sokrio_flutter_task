import 'package:dio/dio.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';

class DioFailureMapper {
  static Failure map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure("Request timeout. Please try again.");

      case DioExceptionType.connectionError:
        return const ServerFailure("No Internet Connection");

      case DioExceptionType.badResponse:
        final message =
            e.response?.data?['message'] ??
            e.response?.statusMessage ??
            "Server error";

        return ServerFailure(message);

      case DioExceptionType.cancel:
        return const ServerFailure("Request cancelled");

      default:
        return const ServerFailure("Unexpected error occurred");
    }
  }
}
