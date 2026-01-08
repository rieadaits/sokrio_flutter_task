import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sokrio_flutter_task/src/core/error/dio_client.dart';
import 'package:sokrio_flutter_task/src/core/error/network_info.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/remote_data_sources/data_sources/users_remote_data_sources.dart';
import 'package:sokrio_flutter_task/src/data/data_sources/remote_data_sources/services/users_services.dart';
import 'package:sokrio_flutter_task/src/data/repositories/user_repositories_impl.dart';
import 'package:sokrio_flutter_task/src/domain/repositories/user_repository.dart';
import 'package:sokrio_flutter_task/src/domain/use_cases/get_users_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Use cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UsersRemoteDataSources>(
    () => UserRemoteDataSourceImpl(usersService: sl()),
  );

  // API Service (Retrofit)
  sl.registerLazySingleton<UsersService>(
    () => UsersService(sl<DioClient>().dio),
  );

  // Core
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(networkInfo: sl()));
}
