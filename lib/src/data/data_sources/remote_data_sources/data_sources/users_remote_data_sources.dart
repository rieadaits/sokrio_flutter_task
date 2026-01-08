import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sokrio_flutter_task/src/core/error/dio_failures_mapper.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/remote_data_sources/services/users_services.dart';
import 'package:sokrio_flutter_task/src/data/models/users_response.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';

abstract class UsersRemoteDataSources {
  Future<Either<Failure, List<UserEntity>>> getUser({
    required int pageNumer,
    required int perPageItems,
  });
}

class UserRemoteDataSourceImpl implements UsersRemoteDataSources {
  final UsersService usersService;
  UserRemoteDataSourceImpl({required this.usersService});

  @override
  Future<Either<Failure, List<UserEntity>>> getUser({
    required int pageNumer,
    required int perPageItems,
  }) async {
    try {
      final userData = await usersService.getUsers(
        page: pageNumer,
        perPage: perPageItems,
      );

      final usersList = userData.userList
          .map((userModel) => userModel.toEntity())
          .toList();
      return Right(usersList);
    } on DioException catch (e) {
      return Left(DioFailureMapper.map(e));
    } catch (_) {
      return const Left(UnknownFailure("Unexpected error occurred"));
    }
  }
}
