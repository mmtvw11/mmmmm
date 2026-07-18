import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TasksEvent {
  const LoadTasks();
}

class LoadNextPage extends TasksEvent {
  const LoadNextPage();
}

class RefreshTasks extends TasksEvent {
  const RefreshTasks();
}

class UpdateTaskStatus extends TasksEvent {
  final int taskId;
  final bool completed;

  const UpdateTaskStatus({
    required this.taskId,
    required this.completed,
  });

  @override
  List<Object> get props => [taskId, completed];
}
