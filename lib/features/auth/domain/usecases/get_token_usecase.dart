import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class GetTokenUseCase extends UseCase<String, NoParams> {
  final AuthRepository repository;

  GetTokenUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getToken();
  }
}
