import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/get_token_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/tasks/data/datasources/tasks_remote_data_source.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/get_task_by_id_usecase.dart';
import '../../features/tasks/domain/usecases/update_task_status_usecase.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // External dependencies
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );
  
  getIt.registerSingleton<http.Client>(
    http.Client(),
  );

  // Auth Data Sources
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(secureStorage: getIt<FlutterSecureStorage>()),
  );

  // Auth Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(localDataSource: getIt<AuthLocalDataSource>()),
  );

  // Auth UseCases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<CheckAuthUseCase>(
    CheckAuthUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetTokenUseCase>(
    GetTokenUseCase(repository: getIt<AuthRepository>()),
  );

  // Auth BLoC
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      checkAuthUseCase: getIt<CheckAuthUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // Tasks Data Sources
  getIt.registerSingleton<TasksRemoteDataSource>(
    TasksRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  // Tasks Repositories
  getIt.registerSingleton<TasksRepository>(
    TasksRepositoryImpl(remoteDataSource: getIt<TasksRemoteDataSource>()),
  );

  // Tasks UseCases
  getIt.registerSingleton<GetTasksUseCase>(
    GetTasksUseCase(repository: getIt<TasksRepository>()),
  );

  getIt.registerSingleton<GetTaskByIdUseCase>(
    GetTaskByIdUseCase(repository: getIt<TasksRepository>()),
  );

  getIt.registerSingleton<UpdateTaskStatusUseCase>(
    UpdateTaskStatusUseCase(repository: getIt<TasksRepository>()),
  );

  // Tasks BLoC
  getIt.registerSingleton<TasksBloc>(
    TasksBloc(
      getTasksUseCase: getIt<GetTasksUseCase>(),
      getTaskByIdUseCase: getIt<GetTaskByIdUseCase>(),
      updateTaskStatusUseCase: getIt<UpdateTaskStatusUseCase>(),
    ),
  );
}
