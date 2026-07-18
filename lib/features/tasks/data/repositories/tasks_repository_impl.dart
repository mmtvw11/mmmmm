import 'package:dartz/dartz.dart';
import '../../../../core/base/paginated_response.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../models/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  List<TaskModel>? _cachedTasks;

  TasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedResponse<TaskEntity>>> getTasks(
    int page,
    int pageSize,
  ) async {
    try {
      // Кэшируем все задачи при первой загрузке
      _cachedTasks ??= await remoteDataSource.getTasks();

      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      final paginatedTasks = _cachedTasks!.sublist(
        startIndex,
        endIndex > _cachedTasks!.length ? _cachedTasks!.length : endIndex,
      );

      final hasNextPage = endIndex < _cachedTasks!.length;
      final totalPages = (_cachedTasks!.length / pageSize).ceil();

      return Right(
        PaginatedResponse<TaskEntity>(
          items: paginatedTasks,
          currentPage: page,
          hasNextPage: hasNextPage,
          totalPages: totalPages,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(int id) async {
    try {
      final task = await remoteDataSource.getTaskById(id);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus(
    int id,
    bool completed,
  ) async {
    try {
      // Обновляем статус локально в кэше
      if (_cachedTasks != null) {
        final taskIndex = _cachedTasks!.indexWhere((task) => task.id == id);
        if (taskIndex != -1) {
          _cachedTasks![taskIndex] = TaskModel(
            id: _cachedTasks![taskIndex].id,
            userId: _cachedTasks![taskIndex].userId,
            title: _cachedTasks![taskIndex].title,
            completed: completed,
          );
          return Right(_cachedTasks![taskIndex]);
        }
      }
      return Left(ServerFailure(message: 'Task not found'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
