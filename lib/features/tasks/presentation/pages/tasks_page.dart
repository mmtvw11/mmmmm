import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/task_list_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../bloc/tasks_bloc.dart';
import '../../domain/entities/task_entity.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<TasksBloc>().add(const LoadTasks());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TasksBloc>().add(const LoadNextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskHub'),
        elevation: 0,
        actions: [
          BlocSelector<TasksBloc, TasksState, int>(
            selector: (state) {
              if (state is TasksLoaded) return state.completedCount;
              if (state is TasksLoadingMore) return state.completedCount;
              if (state is TaskStatusUpdated) return state.completedCount;
              return 0;
            },
            builder: (context, completedCount) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Chip(
                    avatar: const Icon(Icons.done, size: 18),
                    label: Text('$completedCount'),
                    backgroundColor: Colors.green.shade100,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksError) {
            return ErrorState(
              message: state.message,
              onRetry: () {
                context.read<TasksBloc>().add(const LoadTasks());
              },
            );
          }

          if (state is TasksLoaded && state.tasks.isEmpty) {
            return const EmptyState();
          }

          if (state is TasksLoaded || state is TasksLoadingMore) {
            final tasks = state is TasksLoaded
                ? state.tasks
                : (state as TasksLoadingMore).tasks;
            final hasNextPage = state is TasksLoaded
                ? state.hasNextPage
                : (state as TasksLoadingMore).hasNextPage;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TasksBloc>().add(const RefreshTasks());
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: tasks.length + (hasNextPage ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == tasks.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return TaskListItem(
                    task: tasks[index],
                    onStatusChanged: (completed) {
                      context.read<TasksBloc>().add(
                            UpdateTaskStatus(
                              taskId: tasks[index].id,
                              completed: completed,
                            ),
                          );
                    },
                  );
                },
              ),
            );
          }

          return const EmptyState();
        },
      ),
    );
  }
}
