import 'package:get_it/get_it.dart';
import 'package:sokrio_flutter_task/src/core/error/dio_client.dart';
import 'package:sokrio_flutter_task/src/core/error/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async{
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DioClient>(
    () => DioClient(networkInfo: sl()));
}
