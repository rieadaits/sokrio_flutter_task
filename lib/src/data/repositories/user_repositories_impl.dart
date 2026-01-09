import 'package:dartz/dartz.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/local_data_sources/users_local_datasource.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/remote_data_sources/data_sources/users_remote_data_sources.dart';
import 'package:sokrio_flutter_task/src/data/models/users_response.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';
import 'package:sokrio_flutter_task/src/domain/repositories/user_repository.dart';

import '../../core/error/network_info.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSources remoteDataSource;
  final UsersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int pageNumer,
    required int perPageItems,
  }) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getUser(
        pageNumer: pageNumer,
        perPageItems: perPageItems,
      );
      if (result.isRight() && pageNumer == 1) {
        final users = result.getOrElse(() => []).map((user) => user.toModel()).toList();
        await localDataSource.cacheUsers(users);
      }
      return result;
    } else {
      // No internet connection
      try {
        final localRepos = await localDataSource.getLastUsers();
        if (localRepos.isNotEmpty) {
          return Right(localRepos.map((user) => user.toEntity()).toList());
        } else {
          return Left(CacheFailure('No internet connection. Please check your connection and try again.'));
        }
      } on CacheFailure {
        return Left(CacheFailure('No internet connection. Please check your connection and try again.'));
      }
    }
  }
}
