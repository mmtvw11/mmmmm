import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase
    extends UseCase<TaskEntity, UpdateTaskStatusParams> {
  final TasksRepository repository;

  UpdateTaskStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call(
    UpdateTaskStatusParams params,
  ) async {
    return await repository.updateTaskStatus(params.id, params.completed);
  }
}

class UpdateTaskStatusParams {
  final int id;
  final bool completed;

  UpdateTaskStatusParams({required this.id, required this.completed});
}
