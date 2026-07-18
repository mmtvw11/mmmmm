import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {
  const TasksInitial();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksLoaded extends TasksState {
  final List<TaskEntity> tasks;
  final int currentPage;
  final bool hasNextPage;
  final int totalPages;
  final int completedCount;
  final int pendingCount;

  const TasksLoaded({
    required this.tasks,
    required this.currentPage,
    required this.hasNextPage,
    required this.totalPages,
    required this.completedCount,
    required this.pendingCount,
  });

  @override
  List<Object> get props => [
        tasks,
        currentPage,
        hasNextPage,
        totalPages,
        completedCount,
        pendingCount,
      ];
}

class TasksLoadingMore extends TasksState {
  final List<TaskEntity> tasks;
  final int currentPage;
  final bool hasNextPage;
  final int totalPages;
  final int completedCount;
  final int pendingCount;

  const TasksLoadingMore({
    required this.tasks,
    required this.currentPage,
    required this.hasNextPage,
    required this.totalPages,
    required this.completedCount,
    required this.pendingCount,
  });

  @override
  List<Object> get props => [
        tasks,
        currentPage,
        hasNextPage,
        totalPages,
        completedCount,
        pendingCount,
      ];
}

class TasksError extends TasksState {
  final String message;
  final List<TaskEntity>? previousTasks;

  const TasksError({
    required this.message,
    this.previousTasks,
  });

  @override
  List<Object> get props => [message, previousTasks ?? []];
}

class TaskStatusUpdated extends TasksState {
  final List<TaskEntity> tasks;
  final int completedCount;
  final int pendingCount;
  final String message;

  const TaskStatusUpdated({
    required this.tasks,
    required this.completedCount,
    required this.pendingCount,
    required this.message,
  });

  @override
  List<Object> get props => [tasks, completedCount, pendingCount, message];
}
