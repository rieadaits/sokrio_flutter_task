import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sokrio_flutter_task/src/core/error/falures.dart';
import 'package:sokrio_flutter_task/src/core/use_cases/use_case.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';
import 'package:sokrio_flutter_task/src/domain/repositories/user_repository.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, GetUsersParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(params) async {
    final result = await repository.getUsers(
      pageNumer: params.pageNumber,
      perPageItems: params.perPageItems,
    );
    return result.fold(
      (failure) => Left(failure),
      (userEntity) => Right(userEntity),
    );
  }
}

class GetUsersParams extends Equatable {
  final int pageNumber;
  final int perPageItems;

  const GetUsersParams({
    required this.pageNumber,
    required this.perPageItems,
  });
  @override
  List<Object?> get props => [pageNumber, perPageItems];
}