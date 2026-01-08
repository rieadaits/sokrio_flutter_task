import 'package:dartz/dartz.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/remote_data_sources/data_sources/users_remote_data_sources.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';
import 'package:sokrio_flutter_task/src/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSources remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int pageNumer,
    required int perPageItems,
  }) async {
      final result = await remoteDataSource.getUser(
        pageNumer: pageNumer,
        perPageItems: perPageItems,
      );
      return result;
  }
 }