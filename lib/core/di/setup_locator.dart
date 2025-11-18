import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:tambur_create/core/network/connectivity_service.dart';
import 'package:tambur_create/core/network/http_client.dart';
import 'package:tambur_create/core/services/token_service.dart';
import 'package:tambur_create/features/login/data/data_sources/user_remote_data_source.dart';
import 'package:tambur_create/features/login/data/repositories/user_repository_impl.dart';
import 'package:tambur_create/features/login/domain/use_cases/login_user_use_case.dart';
import 'package:tambur_create/features/otk/data/data_sources/otk_remote_data_source.dart';
import 'package:tambur_create/features/otk/data/repositories/otk_repository_impl.dart';
import 'package:tambur_create/features/otk/domain/use_cases/otk_use_case.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<IHttpClient>(() => HttpClient());
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Register ConnectivityService for network monitoring
  locator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );

  // Register TokenService for both the interface and concrete implementation
  final tokenService = TokenService(
    storage: const FlutterSecureStorage(),
    client: HttpClient(),
  );
  locator.registerLazySingleton<ITokenService>(() => tokenService);
  locator.registerLazySingleton<TokenService>(() => tokenService);

  // locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Login

  // Remote Data Source
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(),
  );
  // Repository
  locator.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(locator<UserRemoteDataSource>()),
  );
  // Use Case
  locator.registerLazySingleton<LoginUserUseCase>(
    () => LoginUserUseCase(locator<UserRepositoryImpl>()),
  );

  locator.registerLazySingleton<OtkUseCase>(
    () => OtkUseCase(locator<OtkRepositoryImpl>()),
  );

  locator.registerLazySingleton<OtkRepositoryImpl>(
    () => OtkRepositoryImpl(locator<OtkRemoteDataSource>()),
  );

  locator.registerLazySingleton<OtkRemoteDataSource>(
    () => OtkRemoteDataSource(
      tokenService: locator<ITokenService>(),
      client: locator<IHttpClient>(),
    ),
  );
}
