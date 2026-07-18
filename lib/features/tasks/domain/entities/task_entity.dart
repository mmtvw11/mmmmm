enum TaskStatus { pending, completed }

class TaskEntity {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  TaskStatus get status => completed ? TaskStatus.completed : TaskStatus.pending;
}
