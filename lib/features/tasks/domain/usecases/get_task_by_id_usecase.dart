import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTaskByIdUseCase extends UseCase<TaskEntity, int> {
  final TasksRepository repository;

  GetTaskByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call(int id) async {
    return await repository.getTaskById(id);
  }
}
