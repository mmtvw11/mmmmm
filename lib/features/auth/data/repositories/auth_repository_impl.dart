import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final user = await localDataSource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(
        AuthenticationFailure(message: 'Неверный email или пароль'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(
        AuthenticationFailure(message: 'Ошибка при выходе'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuth() async {
    try {
      final isAuthenticated = await localDataSource.checkAuth();
      return Right(isAuthenticated);
    } catch (e) {
      return Left(
        AuthenticationFailure(message: 'Ошибка проверки авторизации'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(
        AuthenticationFailure(message: 'Ошибка получения токена'),
      );
    }
  }
}
