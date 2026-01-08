import 'package:dartz/dartz.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int pageNumer,
    required int perPageItems,
  });
}
