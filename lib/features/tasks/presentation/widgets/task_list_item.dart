import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItem extends StatefulWidget {
  final TaskEntity task;
  final Function(bool) onStatusChanged;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          child: ListTile(
            leading: Checkbox(
              value: widget.task.completed,
              onChanged: (value) {
                if (value != null) {
                  widget.onStatusChanged(value);
                }
              },
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                decoration: widget.task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: widget.task.completed
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
            trailing: Chip(
              label: Text(
                widget.task.completed ? 'Выполнено' : 'В ожидании',
              ),
              backgroundColor: widget.task.completed
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
            ),
          ),
        ),
      ),
    );
  }
}
