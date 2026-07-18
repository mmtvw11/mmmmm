import 'package:dartz/dartz.dart';
import '../../../../core/base/paginated_response.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase
    extends UseCase<PaginatedResponse<TaskEntity>, GetTasksParams> {
  final TasksRepository repository;

  GetTasksUseCase({required this.repository});

  @override
  Future<Either<Failure, PaginatedResponse<TaskEntity>>> call(
    GetTasksParams params,
  ) async {
    return await repository.getTasks(params.page, params.pageSize);
  }
}

class GetTasksParams {
  final int page;
  final int pageSize;

  GetTasksParams({this.page = 1, this.pageSize = 20});
}
