import 'package:dartz/dartz.dart';
import '../../../../core/base/paginated_response.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, PaginatedResponse<TaskEntity>>> getTasks(
    int page,
    int pageSize,
  );
  Future<Either<Failure, TaskEntity>> getTaskById(int id);
  Future<Either<Failure, TaskEntity>> updateTaskStatus(int id, bool completed);
}
